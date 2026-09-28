return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  opts = {
    -- Custom mux backend (lua/smart-splits/mux/herdr.lua in this repo's
    -- nvim config) shells out to `herdr pane` since upstream smart-splits
    -- only ships tmux/wezterm/kitty/zellij backends.
    multiplexer_integration = "herdr",
  },
}
