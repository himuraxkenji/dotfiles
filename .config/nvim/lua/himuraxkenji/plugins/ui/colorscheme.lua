return {
  -- {
  -- 	"bluz71/vim-nightfly-colors",
  -- 	name = "nightfly",
  -- 	lazy = false,
  -- 	priority = 1000,
  -- 	config = function()
  -- 		vim.cmd([[colorscheme nightfly]])
  -- 	end,
  -- },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme catppuccin]])
    end,
  },
}
