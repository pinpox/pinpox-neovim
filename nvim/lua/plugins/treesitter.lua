return {
	{
		dir = pluginpaths  .. "/nvim-treesitter",
		name = "nvim-treesitter",

		dependencies = {
			{dir = pluginpaths  .. "/playground"},
		},

		config = function()

			require'nvim-treesitter.configs'.setup {

				-- ensure_installed = { },
				-- Install ascynchroniously
				-- sync_install = false,
				--
				-- Broken on nixos?
				auto_install = false,

				highlight = {
					enable = true,

					-- Disable specific languages
					-- disable = { "c", "rust" },

					additional_vim_regex_highlighting = false,
				},
			}
		end,
	},
}


