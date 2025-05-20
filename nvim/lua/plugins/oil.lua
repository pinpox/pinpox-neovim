return {
	-- TODO: check out https://github.com/kdheepak/lazygit.nvim
	-- {
	-- 	dir = pluginpaths .. "/diffview.nvim",
	-- 	name = "diffview-nvim",
	-- 	config = function()
	-- 		require("diffview").setup()
	-- 	end,
	-- },

	{
		dir = pluginpaths .. "/oil.nvim",
		opts = {},
		-- Optional dependencies
		-- dependencies = { { "echasnovski/mini.icons", opts = {} } },
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,

		name = "oil-nvim",
		config = function()
			require("oil").setup()
		end,
	},
}
