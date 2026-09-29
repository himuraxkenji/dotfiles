-- Kulala-like env handling for rest.nvim: pick an env once (:RestEnv [name]), applies to all http buffers.
-- Why: rest.nvim only loads an env file when b:_rest_nvim_env_file is set (its upward `.env` fallback is never
-- called), so the env must be registered per buffer via rest-nvim.dotenv.register_file.
-- Envs are the `.env.<name>` files in nvim's cwd, discovered at use time (no hardcoded path), so `nvim .` from
-- any folder works and `:cd` switches to that folder's envs. State is the env NAME; the path is resolved from
-- the cwd on every apply. The require lives inside apply(): rest.nvim is lazy-loaded (ft = "http").
local current ---@type string?

-- `.env.example` and friends are templates (placeholder values), never a real target
local templates = { example = true, sample = true, template = true }

local function envs()
  local names = {}
  for name, type in vim.fs.dir(vim.fn.getcwd()) do
    local suffix = name:match("^%.env%.(.+)$")
    if suffix and not templates[suffix] and (type == "file" or type == "link") then
      table.insert(names, suffix)
    end
  end
  table.sort(names)
  return names
end

local function env_path(name)
  return vim.fn.getcwd() .. "/.env." .. name
end

-- Returns the active env name, falling back to a default when current is unset or gone from the cwd
local function resolve()
  local names = envs()
  if current and vim.tbl_contains(names, current) then
    return current
  end
  current = vim.tbl_contains(names, "dev") and "dev" or names[1]
  return current
end

local function apply(bufnr, path)
  if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "http" then
    return
  end
  if vim.b[bufnr]._rest_nvim_env_file == path then
    return
  end
  require("rest-nvim.dotenv").register_file(path, bufnr)
end

local function apply_all(bufs)
  local name = resolve()
  if not name then
    return
  end
  local path = env_path(name)
  for _, b in ipairs(bufs or vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) then
      apply(b, path)
    end
  end
end

local function select_env(name)
  local names = envs()
  if not vim.tbl_contains(names, name) then
    vim.notify(
      ("unknown env '%s' in %s (available: %s)"):format(name, vim.fn.getcwd(), table.concat(names, ", ")),
      vim.log.levels.WARN
    )
    return
  end
  current = name
  apply_all()
  vim.notify(("rest env: %s (%s)"):format(name, env_path(name)))
end

vim.api.nvim_create_user_command("RestEnv", function(o)
  if o.args ~= "" then
    return select_env(o.args)
  end
  local names = envs()
  if #names == 0 then
    return vim.notify("no .env.* files in " .. vim.fn.getcwd(), vim.log.levels.WARN)
  end
  vim.ui.select(names, { prompt = "REST environment" }, function(choice)
    if choice then
      select_env(choice)
    end
  end)
end, {
  nargs = "?",
  complete = envs,
})

local group = vim.api.nvim_create_augroup("rest_env", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
  group = group,
  -- FileType matches the filetype, BufEnter matches the buffer name, so list both
  pattern = { "http", "*.http", "*.rest" },
  callback = function(a)
    apply_all({ a.buf })
  end,
})

-- :cd switches the envs, so re-point every loaded http buffer at the new folder's env file
vim.api.nvim_create_autocmd("DirChanged", {
  group = group,
  callback = function()
    apply_all()
  end,
})

-- autocmds.lua loads on VeryLazy, after the first buffer may already be open
apply_all()
