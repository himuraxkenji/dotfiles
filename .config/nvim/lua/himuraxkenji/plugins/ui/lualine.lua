return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "meuter/lualine-so-fancy.nvim",
  },
  event = "VeryLazy",
  opts = function()
    return {
      options = {
        theme = "catppuccin",
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        refresh = {
          statusline = 100,
        },
      },
      sections = {
        lualine_a = {
          { "fancy_mode", width = 3 },
        },
        lualine_b = {
          { "fancy_branch" },
          { "fancy_diff" },
        },
        lualine_c = {
          { "fancy_cwd", substitute_home = true },
        },
        lualine_x = {
          { "fancy_diagnostics" },
          { "fancy_searchcount" },
          { "fancy_location" },
        },
        lualine_y = {
          { "fancy_filetype", ts_icon = "" },
        },
        lualine_z = {
          { "fancy_lsp_servers" },
        },
      },
    }
  end,
  config = function(_, opts)
    require("lualine").setup(opts)
  end,
}
-- return {
-- 	"nvim-lualine/lualine.nvim",
-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
-- 	config = function()
-- 		require("lualine").setup({
-- 			options = {
-- 				theme = "catppuccin",
-- 				-- section_separators = { "", "" },
-- 				-- component_separators = { "", "" },
-- 				icons_enabled = true,
-- 			},
-- 		})
-- 	end,
-- config = function()
-- 	local lualine = require("lualine")
-- 	local lazy_status = require("lazy.status") -- to configure lazy pending updates count
--
-- 	local colors = {
-- 		blue = "#65D1FF",
-- 		green = "#3EFFDC",
-- 		violet = "#FF61EF",
-- 		yellow = "#FFDA7B",
-- 		red = "#FF4A4A",
-- 		fg = "#c3ccdc",
-- 		bg = "#112638",
-- 		inactive_bg = "#2c3043",
-- 	}
--
-- 	local my_lualine_theme = {
-- 		normal = {
-- 			a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
-- 			b = { bg = colors.bg, fg = colors.fg },
-- 			c = { bg = colors.bg, fg = colors.fg },
-- 		},
-- 		insert = {
-- 			a = { bg = colors.green, fg = colors.bg, gui = "bold" },
-- 			b = { bg = colors.bg, fg = colors.fg },
-- 			c = { bg = colors.bg, fg = colors.fg },
-- 		},
-- 		visual = {
-- 			a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
-- 			b = { bg = colors.bg, fg = colors.fg },
-- 			c = { bg = colors.bg, fg = colors.fg },
-- 		},
-- 		command = {
-- 			a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
-- 			b = { bg = colors.bg, fg = colors.fg },
-- 			c = { bg = colors.bg, fg = colors.fg },
-- 		},
-- 		replace = {
-- 			a = { bg = colors.red, fg = colors.bg, gui = "bold" },
-- 			b = { bg = colors.bg, fg = colors.fg },
-- 			c = { bg = colors.bg, fg = colors.fg },
-- 		},
-- 		inactive = {
-- 			a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
-- 			b = { bg = colors.inactive_bg, fg = colors.semilightgray },
-- 			c = { bg = colors.inactive_bg, fg = colors.semilightgray },
-- 		},
-- 	}
--
-- 	-- configure lualine with modified theme
-- 	lualine.setup({
-- 		options = {
-- 			theme = my_lualine_theme,
-- 		},
-- 		sections = {
-- 			lualine_x = {
-- 				{
-- 					lazy_status.updates,
-- 					cond = lazy_status.has_updates,
-- 					color = { fg = "#ff9e64" },
-- 				},
-- 				{ "encoding" },
-- 				{ "fileformat" },
-- 				{ "filetype" },
-- 			},
-- 		},
-- 	})
-- end,
-- }
