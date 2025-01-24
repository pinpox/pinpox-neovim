return {
	{
		-- dir = pluginpaths .. "/wastebin.nvim",
		"matze/wastebin.nvim",
		name = "wastebin.nvim",
		config = function()
			require("wastebin").setup({
				url = "https://paste.0cx.de",
			})
		end,
	},
}
