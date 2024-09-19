return {
	{
		name = "nvim-highlight-colors",
		dir = plugin_dirs["nvim-highlight-colors"],
		config = function()
			vim.opt.termguicolors = true
			require('nvim-highlight-colors').setup({})
		end,
	},
}

