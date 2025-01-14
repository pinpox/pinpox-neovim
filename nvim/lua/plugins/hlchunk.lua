local nixcolors = require("nixcolors")

return {
	{
		-- TODO: add to nixpkgs and use pluginpaths
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("hlchunk").setup({
				line_num = {
					enable = true,
					style = nixcolors.Cyan,
				},

				indent = { enable = true },

				chunk = {
					enable = true,
					style = {
						{ fg = nixcolors.BrightWhite},
						{ fg = nixcolors.BrightRed },
					},
				},
			})
		end,
	},
}
