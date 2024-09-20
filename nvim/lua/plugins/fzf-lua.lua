return {
	{
		dir = pluginpaths  .. "/zk-nvim",
		name = "zk-nvim",
		dependencies = {{ dir = pluginpaths .. "/nvim-web-devicons" }},
		config = function()

			require("nvim-web-devicons").setup({
				-- globally enable default icons (default to false)
				-- will get overriden by `get_icons` option
				default = true;

			})

			require("fzf-lua").setup({})
		end,
	},
}
