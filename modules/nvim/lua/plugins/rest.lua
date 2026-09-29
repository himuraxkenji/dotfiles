-- HTTP client for .http files (replaces kulala.nvim)
-- Plugin: rest-nvim/rest.nvim (v3, no setup() call; configured via vim.g.rest_nvim)
-- Requires: curl, `http` treesitter parser, lua rocks (installed by lazy.nvim from the plugin rockspec;
-- lazy falls back to hererocks when luarocks is not on PATH, which needs python3 + a C compiler)

-- Filetype detection for .http / .rest files
vim.filetype.add({ extension = { http = "http", rest = "http" } })

vim.g.rest_nvim = {}

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

  {
    "rest-nvim/rest.nvim",
    ft = "http",
    cmd = "Rest",
    keys = {
      { "<leader>r", "", desc = "+rest", ft = "http" },
      { "<CR>", "<cmd>Rest run<cr>", mode = "n", desc = "Rest: run request under cursor", ft = "http" },
      { "<leader>rr", "<cmd>Rest run<cr>", desc = "Rest: run request", ft = "http" },
      { "<leader>rl", "<cmd>Rest last<cr>", desc = "Rest: run last request", ft = "http" },
      { "<leader>re", "<cmd>Rest env select<cr>", desc = "Rest: select env file", ft = "http" },
      { "<leader>ro", "<cmd>Rest open<cr>", desc = "Rest: open result pane", ft = "http" },
      { "<leader>rc", "<cmd>Rest cookies<cr>", desc = "Rest: edit cookies", ft = "http" },
      { "<leader>rL", "<cmd>Rest logs<cr>", desc = "Rest: view logs", ft = "http" },
    },
  },
}
