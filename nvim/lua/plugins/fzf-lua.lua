return {
	{
		dir = pluginpaths .. "/fzf-lua",
		name = "fzf-lua",
		dependencies = { { dir = pluginpaths .. "/nvim-web-devicons" } },
		config = function()

		print(pluginpaths)
			require("nvim-web-devicons").setup({
				-- globally enable default icons (default to false)
				-- will get overriden by `get_icons` option
				default = true,
			})

			require("fzf-lua").setup({
				grep = {
					actions = {
						["alt-q"] = {
							fn = require("fzf-lua").actions.file_edit_or_qf,
							prefix = "select-all+",
						},
					},
				},
			})
		end,
	},
}
