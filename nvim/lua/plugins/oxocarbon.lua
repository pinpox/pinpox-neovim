return {
	{
		dir = pluginpaths .. "/oxocarbon.nvim",
		name = "oxocarbon-nvim",
		config = function()
			vim.cmd("colorscheme wildcharm")

			-- Set pure black background
			-- vim.api.nvim_set_hl(0, "Normal", { bg = "Black" })
			-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "Black" })
			-- vim.api.nvim_set_hl(0, "NormalNC", { bg = "Black" })
		end,
	},
}
