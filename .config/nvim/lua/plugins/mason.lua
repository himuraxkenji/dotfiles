return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "selene",

        "shellcheck",
        "shfmt",
        -- frontend
        -- "angularls",
        "prettier",
        "eslint-lsp",
        -- rust
        "rust-analyzer",
        -- markdown
        "markdownlint",
        "marksman",
        -- go
        "gofumpt",
        "gopls",
        "goimports",
        -- docker
        "hadolint",

        "codelldb",
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = { "python", "delve" },
    },
    -- mason-nvim-dap is loaded when nvim-dap loads
    config = function() end,
  },
}
