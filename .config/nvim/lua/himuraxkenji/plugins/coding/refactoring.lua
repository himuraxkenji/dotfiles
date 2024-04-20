-- https://github.com/ThePrimeagen/refactoring.nvim
return {
	"ThePrimeagen/refactoring.nvim",
	config = function()
		require("refactoring").setup()
	end,
	keys = {
		{
			"<leader>r",
			function()
				require("refactoring").select_refactor()
			end,
			mode = "v",
			noremap = true,
			silent = true,
			expr = false,
		},
	},
}
