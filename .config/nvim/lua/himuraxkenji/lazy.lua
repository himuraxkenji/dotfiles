local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ import = "himuraxkenji.plugins" },
	{ import = "himuraxkenji.plugins.lsp" },
	{ import = "himuraxkenji.plugins.coding" },
	{ import = "himuraxkenji.plugins.ui" },
	{ import = "himuraxkenji.plugins.git" },
}, {
	install = {
		colorscheme = { "nightfly" },
	},
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})
