-- HTTP client for .http files (replaces kulala.nvim)
-- Plugin: rest-nvim/rest.nvim (v3, no setup() call; configured via vim.g.rest_nvim)
-- Requires: curl, `http` treesitter parser, lua rocks (installed by lazy.nvim from the plugin rockspec;
-- lazy falls back to hererocks when luarocks is not on PATH, which needs python3 + a C compiler)

-- Filetype detection for .http / .rest files
vim.filetype.add({ extension = { http = "http", rest = "http" } })

vim.g.rest_nvim = {}

-- Hover-like preview (kulala's `K`): shows the request under the cursor with {{vars}} resolved against the
-- env file selected via `:Rest env select` + inline `@var = value` declarations. It never executes the request.
-- Coupling: uses rest.nvim internals (parser.get_request_node/eval_context/parse_variable_declaration,
-- context.Context, buffer var b:_rest_nvim_env_file). Deliberately NOT parser.parse(): that would also run
-- pre-request scripts and `# @prompt` inputs. Verified against rest.nvim v3.13.0.
local function preview_request()
  local ok, err = pcall(function()
    local parser = require("rest-nvim.parser")
    local node = parser.get_request_node()
    if not node then
      return
    end
    local buf = vim.api.nvim_get_current_buf()
    local env_file = vim.b[buf]._rest_nvim_env_file
    local ctx = require("rest-nvim.context").Context:new()
    if env_file and require("rest-nvim.config").env.enable then
      ctx:load_file(env_file)
    end
    -- inline variables declared above the request, then those inside the request's own section
    parser.eval_context(buf, ctx, (node:range()))
    for child in node:iter_children() do
      if child:type() == "variable_declaration" then
        parser.parse_variable_declaration(child, buf, ctx)
      end
    end

    local unresolved, seen = {}, {}
    local function expand(s)
      s = s:gsub("%$dotenv ", ""):gsub("%$DOTENV ", "")
      return (s:gsub("{{(.-)}}", function(name)
        name = vim.trim(name)
        local value = ctx:resolve(name)
        if name:sub(1, 1) == "$" and value ~= "" then
          return "{{" .. name .. "}}" -- dynamic ($uuid, $timestamp...): generated at run time, keep as is
        elseif value == "" then
          if not seen[name] then
            seen[name] = true
            table.insert(unresolved, name)
          end
          return "{{" .. name .. "}}"
        end
        return value
      end))
    end

    local function text(n, field)
      local f = n:field(field)[1]
      return f and vim.treesitter.get_node_text(f, buf) or nil
    end

    local req = node:field("request")[1]
    local url = (text(req, "url") or ""):gsub("\n%s+", "")
    local lines = { (text(req, "method") or "GET") .. " " .. expand(url) }
    for _, h in ipairs(req:field("header")) do
      local value = text(h, "value")
      table.insert(lines, expand(text(h, "name") or "") .. ": " .. (value and expand(value) or ""))
    end
    table.insert(lines, "")
    table.insert(lines, "env: " .. (env_file and vim.fn.fnamemodify(env_file, ":~:.") or "none selected (<leader>re)"))
    if #unresolved > 0 then
      table.insert(lines, "WARN unresolved/empty: " .. table.concat(unresolved, ", "))
    end

    local fbuf = vim.lsp.util.open_floating_preview(lines, "http", { border = "rounded", focus_id = "rest_preview" })
    for _, key in ipairs({ "q", "<Esc>" }) do
      vim.keymap.set("n", key, "<cmd>close<cr>", { buffer = fbuf, nowait = true, silent = true })
    end
  end)
  if not ok then
    vim.notify("Rest preview failed: " .. tostring(err), vim.log.levels.ERROR, { title = "rest.nvim" })
  end
end

-- Go to the file referenced by an external body (`< ./f.json`, `<@ ./f.json`, `<@ latin1 ./f.json`), like
-- kulala's `gd`. Relative paths resolve against the .http buffer's directory (as rest.nvim's parser does).
-- `{{var}}` paths are not expanded. Other lines fall back to Vim's builtin `gd` (`normal!` = no mapping recursion).
local function goto_referenced_file()
  local rest = vim.api.nvim_get_current_line():match("^%s*<@?%s+(.-)%s*$")
  if not rest or rest == "" then
    return vim.cmd("normal! gd")
  end
  rest = rest:gsub("^([\"'])(.*)%1$", "%2")
  if rest:find("{{", 1, true) then
    return vim.notify("Rest: {{var}} in file path is not supported: " .. rest, vim.log.levels.WARN, { title = "rest.nvim" })
  end
  local base = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
  local function resolve(p)
    p = vim.fn.expand(p) -- ~ and $ENV
    return vim.fs.normalize(vim.startswith(p, "/") and p or vim.fs.joinpath(base, p))
  end
  local path = resolve(rest)
  if not vim.uv.fs_stat(path) then
    local stripped = rest:match("^%S+%s+(.+)$") -- `<@ latin1 ./f`: first word is the encoding
    if stripped and vim.uv.fs_stat(resolve(stripped)) then
      path = resolve(stripped)
    else
      return vim.notify("Rest: file not found: " .. path, vim.log.levels.WARN, { title = "rest.nvim" })
    end
  end
  vim.cmd.edit(vim.fn.fnameescape(path))
end

return {
  -- Treesitter parser for http
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "http" })
      end
    end,
  },

  -- LazyVim sets a buffer-local `K` = vim.lsp.buf.hover (via Snacks.keymap, debounced after LspAttach) that
  -- overrides the lazy `keys` mapping below whenever ANY client (e.g. copilot) attaches to an http buffer.
  -- Same lhs as LazyVim's entry, so it replaces it; `enabled` skips http buffers and keeps rest's `K`.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            {
              "K",
              function()
                return vim.lsp.buf.hover()
              end,
              desc = "Hover",
              enabled = function(buf)
                return vim.bo[buf].filetype ~= "http"
              end,
            },
          },
        },
      },
    },
  },

  {
    "rest-nvim/rest.nvim",
    ft = "http",
    cmd = "Rest",
    keys = {
      { "<leader>r", "", desc = "+rest", ft = "http" },
      { "<CR>", "<cmd>Rest run<cr>", mode = "n", desc = "Rest: run request under cursor", ft = "http" },
      { "K", preview_request, mode = "n", desc = "Rest: preview request (resolved vars)", ft = "http" },
      { "gd", goto_referenced_file, mode = "n", desc = "Rest: go to referenced file", ft = "http" },
      { "<leader>rr", "<cmd>Rest run<cr>", desc = "Rest: run request", ft = "http" },
      { "<leader>rl", "<cmd>Rest last<cr>", desc = "Rest: run last request", ft = "http" },
      { "<leader>re", "<cmd>Rest env select<cr>", desc = "Rest: select env file", ft = "http" },
      { "<leader>ro", "<cmd>Rest open<cr>", desc = "Rest: open result pane", ft = "http" },
      { "<leader>rc", "<cmd>Rest cookies<cr>", desc = "Rest: edit cookies", ft = "http" },
      { "<leader>rL", "<cmd>Rest logs<cr>", desc = "Rest: view logs", ft = "http" },
    },
  },
}
