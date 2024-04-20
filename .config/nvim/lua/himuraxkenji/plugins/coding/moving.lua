-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-bracketed.md
return {
	"echasnovski/mini.nvim",
	event = "BufReadPost",
	config = function()
		local bracketed = require("mini.bracketed")
		bracketed.setup({
			file = { suffix = "" },
			window = { suffix = "" },
			quickfix = { suffix = "" },
			yank = { suffix = "" },
			treesitter = { suffix = "n" },
		})
	end,
}
