return {
  {
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      -- Force eager loading. Without this, lazy.nvim never runs this
      -- plugin's config() before LazyVim's own init() calls
      -- `vim.cmd.colorscheme(...)`, which resolves `require("catppuccin")`
      -- straight off the runtimepath and skips setup()/config() entirely —
      -- so it always applies default (opaque) options, not ours below.
      lazy = false,
      opts = {
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = true, -- disables setting the background color.
        term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
      },
      -- catppuccin caches its compiled colorscheme on disk and only recompiles
      -- when its options hash changes. If LazyVim applies the colorscheme
      -- before this plugin's setup() runs with the opts above, it compiles
      -- (and applies) an opaque cache first. Calling setup() + colorscheme
      -- together here guarantees the transparent opts are live before load.
      config = function(_, opts)
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme("catppuccin")
      end,
    },
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "catppuccin",
      },
    },
  },
}
