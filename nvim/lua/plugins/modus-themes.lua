return {
	{
		dir = pluginpaths .. "/modus-themes.nvim",
		name = "modus-themes-nvim",
		config = function()
			-- Modus themes are available but not activated
			-- Available themes: modus_operandi (light), modus_vivendi (dark)
			-- Uncomment to use:
			-- vim.cmd("colorscheme modus_operandi")
			-- or
			-- vim.cmd("colorscheme modus_vivendi")
		end,
	},
}
