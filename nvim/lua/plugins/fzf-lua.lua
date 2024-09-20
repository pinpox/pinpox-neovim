return {
	{
		dir = pluginpaths  .. "/zk-nvim",
		name = "zk-nvim",
		dependencies = {{ dir = pluginpaths .. "/nvim-web-devicons" }},
		config = function()
			require("fzf-lua").setup({})
		end,
	},
}
