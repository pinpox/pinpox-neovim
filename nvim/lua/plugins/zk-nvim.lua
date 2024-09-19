require("lazy").setup({
	spec = {
		{
			dir = plugin_dirs["zk-nvim"],
			name = "zk-nvim",
			config = function()
				require("zk").setup({
					-- See Setup section below
				})
			end,
		},
	},
})

