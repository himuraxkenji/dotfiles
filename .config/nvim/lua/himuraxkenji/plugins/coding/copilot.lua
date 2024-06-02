return {
  -- {
  -- 	"github/copilot.vim",
  -- },
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      local supermaven = require("supermaven-nvim")
      supermaven.setup({
        -- keymaps = {
        --   accept_suggestion = "<C-g>",
        --   clear_suggestions = "<C-l>",
        --   accept_word = "<C-j>",
        -- },
        -- disable_inline_completion = true to use with cmp and all supermaven as cp source
        -- disable_inline_completion = false,
        -- disable_keymaps = false,
      })
    end,
  },
}
