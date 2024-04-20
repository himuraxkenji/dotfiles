-- https://github.com/folke/zen-mode.nvim
return {
	"folke/zen-mode.nvim",
	cmd = "ZenMode",
	opts = {
		plugins = {
			gitsigns = true,
			tmux = true,
			kitty = { enabled = false, font = "+2" },
		},
	},
	keys = { { "<leader>z", "<cmd>ZenMode<CR>", desc = "Zen Mode" } },
}
