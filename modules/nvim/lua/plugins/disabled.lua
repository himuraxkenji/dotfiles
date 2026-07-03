-- This file contains the configuration for disabling specific Neovim plugins.

return {
  {
    -- Plugin: bufferline.nvim
    -- URL: https://github.com/akinsho/bufferline.nvim
    -- Description: A snazzy buffer line (with tabpage integration) for Neovim.
    "akinsho/bufferline.nvim",
    enabled = false, -- Disable this plugin
  },
  {
    "tris203/precognition.nvim",
    enabled = false,
  },
  {
    -- Plugin: claude-code.nvim
    -- URL: https://github.com/greggh/claude-code.nvim
    -- Description: Neovim integration for Claude Code AI assistant
    "coder/claudecode.nvim",
    enabled = true,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
  },
}
