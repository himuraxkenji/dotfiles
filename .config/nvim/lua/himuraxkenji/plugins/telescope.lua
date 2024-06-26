return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local trouble = require("trouble.providers.telescope")

    telescope.setup({
      defaults = {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",

          -- Exclude some patterns from search
          "--glob=!**/.git/*",
          "--glob=!**/.idea/*",
          "--glob=!**/.vscode/*",
          "--glob=!**/build/*",
          "--glob=!**/dist/*",
          "--glob=!**/yarn.lock",
          "--glob=!**/package-lock.json",
        },

        -- path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<c-t>"] = trouble.open_with_trouble,
          },
          n = { ["<c-t>"] = trouble.open_with_trouble },
        },
        find_files = {
          hidden = true,
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          -- needed to exclude some files & dirs from general search
          -- when not included or specified in .gitignore
          find_command = {
            "rg",
            "--files",
            "--hidden",
            "--glob=!**/.git/*",
            "--glob=!**/.idea/*",
            "--glob=!**/.vscode/*",
            "--glob=!**/build/*",
            "--glob=!**/dist/*",
            "--glob=!**/yarn.lock",
            "--glob=!**/package-lock.json",
          },
        },
      },
    })

    telescope.load_extension("fzf")

    -- Add to search envfile to rest
    -- telescope.load_extension("rest")
    -- then use it, you can also use the `:Telescope rest select_env` command
    -- require("telescope").extensions.rest.select_env()

    local keymap = vim.keymap -- for conciseness
    -- set keymaps

    keymap.set(
      "n",
      "<leader><leader>",
      "<cmd>Telescope smart_open<cr>",
      { desc = "Fuzzy find smart open", noremap = true }
    )
    keymap.set("n", "<leader>fu", "<cmd>Telescope undo<cr>", { desc = "Fuzzy find undo history", noremap = true })
    keymap.set("n", "<leader>fm", "<cmd>Telescope media_files<cr>", { desc = "Fuzzy find media files", noremap = true })
    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find all todo in folder" })
    keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find open buffers" })
    keymap.set(
      "n",
      "<leader>fe",
      "<cmd>Telescope treesitter<cr>",
      { desc = "List function names, variables, from Treesitter" }
    )

    -- TODO: Review this section
    keymap.set("n", "<Leader>sr", "<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", silent)
    keymap.set(
      "n",
      "<Leader>sR",
      "<CMD>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>",
      silent
    )
    keymap.set("n", "<Leader>sn", "<CMD>lua require('telescope').extensions.notify.notify()<CR>", silent)
  end,
}
