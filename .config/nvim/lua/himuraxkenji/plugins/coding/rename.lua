-- TODO: Check if is necesary why in config use lsp
-- https://github.com/smjonas/inc-rename.nvim
return {
  "smjonas/inc-rename.nvim",
  config = function()
    require("inc_rename").setup()
  end,
}
