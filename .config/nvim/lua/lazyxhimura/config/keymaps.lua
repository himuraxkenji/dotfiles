-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
local set = vim.keymap.set
set("n", "<leader>wl", "<C-W>w", { desc = "Save file", remap = true })
set("n", "<leader>wq", "<CMD>wq<CR>", { desc = "Save File And Quit", silent = true })

set("n", "<leader>dd", LazyVim.ui.bufremove, { desc = "Delete Buffer", silent = true })

set("n", "i", function()
  return string.match(vim.api.nvim_get_current_line(), "%g") == nil and "cc" or "i"
end, { expr = true, noremap = true })

set("n", "<leader>fB", "<cmd>Telescope file_browser<cr>", { desc = "File browser", noremap = true })
set("n", "<leader>fu", "<cmd>Telescope undo<cr>", { desc = "Undo history", noremap = true })
set("n", "<leader>fm", "<cmd>Telescope media_files<cr>", { desc = "Media files", noremap = true })
set("n", "<leader><leader>", "<cmd>Telescope smart_open<cr>", { desc = "Smart open", noremap = true })
