return {
	{
		dir = pluginpaths .. "/oxocarbon.nvim",
		name = "oxocarbon-nvim",
		config = function()
			vim.cmd("colorscheme wildcharm")

			-- Make Nix code less pink
			vim.api.nvim_set_hl(0, '@variable.member', { link = 'Normal' })

			-- Set pure black background
			-- vim.api.nvim_set_hl(0, "Normal", { bg = "Black" })
			-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "Black" })
			-- vim.api.nvim_set_hl(0, "NormalNC", { bg = "Black" })
		end,
	},
}
