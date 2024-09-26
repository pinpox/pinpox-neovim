return {
	{
		name = "conform-nvim",
		dir = pluginpaths .. "/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					-- Conform will run multiple formatters sequentially
					python = { "isort", "black" },
					-- You can customize some of the format options for the filetype (:help conform.format)
					rust = { "rustfmt", lsp_format = "fallback" },
					nix = { "nixfmt", lsp_format = "fallback" },
				},
			})
		end,
	},
}
