return {
	-- TODO: check out https://github.com/kdheepak/lazygit.nvim
	{
		dir = pluginpaths .. "/diffview.nvim",
		name = "diffview-nvim",
		config = function()
			require("diffview").setup()
		end,
	},
	{
		dir = pluginpaths .. "/committia.vim",
		name = "committia-vim",
		-- config = function() end,
	},
	{
		dir = pluginpaths .. "/gitsigns.nvim",
		name = "gitsigns-nvim",
		config = function()
			require("gitsigns").setup({

				signs = {

					-- copy from : https://en.wikipedia.org/wiki/Box-drawing_character
					add = { text = "┃" },
					change = { text = "┇" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "┇" },
				},

				numhl = false,
				linehl = false,
				watch_gitdir = {
					interval = 1000,
				},
				current_line_blame = false,
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				-- use_internal_diff = true,  -- If luajit is present
				diff_opts = {
					internal = true,
				},
			})
		end,
	},
}
