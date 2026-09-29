-- Kulala-like env handling for rest.nvim: pick an env once (:RestEnv dev|staging|prod), applies to all http buffers.
-- Why: rest.nvim only loads an env file when b:_rest_nvim_env_file is set (its upward `.env` fallback is never
-- called), so the env must be registered per buffer via rest-nvim.dotenv.register_file.
-- The require lives inside apply(): rest.nvim is lazy-loaded (ft = "http"), lazy resolves the module on demand.
local root = vim.fn.expand("~/code/http")
local current = root .. "/.env.dev"

local function apply(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "http" then
    return
  end
  if vim.b[bufnr]._rest_nvim_env_file == current then
    return
  end
  require("rest-nvim.dotenv").register_file(current, bufnr)
end

vim.api.nvim_create_user_command("RestEnv", function(o)
  current = root .. "/.env." .. o.args
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) then
      apply(b)
    end
  end
end, {
  nargs = 1,
  complete = function()
    return { "dev", "staging", "prod" }
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
  group = vim.api.nvim_create_augroup("rest_env", { clear = true }),
  -- FileType matches the filetype, BufEnter matches the buffer name, so list both
  pattern = { "http", "*.http", "*.rest" },
  callback = function(a)
    apply(a.buf)
  end,
})

-- autocmds.lua loads on VeryLazy, after the first buffer may already be open
for _, b in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_loaded(b) then
    apply(b)
  end
end
