return {
	{
		dir = pluginpaths .. "/nvim-treesitter",
		name = "nvim-treesitter",

		config = function()
			vim.opt.runtimepath:append("~/.local/share/treesitter-grammars")

			-- nvim-treesitter no longer uses require("nvim-treesitter.configs").setup()
			-- Highlighting and folding are now configured via vim.treesitter
			vim.treesitter.start = vim.treesitter.start or function() end
		end,
	},
}
