-- Templ language support
-- Requires: templ LSP installed via Mason

-- Filetype detection for .templ files
vim.filetype.add({ extension = { templ = "templ" } })

return {
  -- Treesitter parser for templ
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "templ", "html" })
      end
    end,
  },

  -- LSP: templ server (binario instalado via Mason)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        templ = {},
      },
    },
  },

  -- Formatter: templ fmt
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        templ = { "templ" },
      },
    },
  },
}
