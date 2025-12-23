return {
	{
		dir = pluginpaths .. "/nvim-treesitter",
		name = "nvim-treesitter",

		config = function()
			-- TODO: install this properly via nix instead of running :TSInstall all
			-- https://discourse.nixos.org/t/psa-if-you-are-on-unstable-try-out-nvim-treesitter-withallgrammars/23321/6

			vim.opt.runtimepath:append("~/.local/share/treesitter-grammars")

			require("nvim-treesitter.configs").setup({

				parser_install_dir = "~/.local/share/treesitter-grammars",

				-- ensure_installed = { },
				-- Install ascynchroniously
				-- sync_install = false,
				--
				-- Broken on nixos?
				auto_install = false,

				fold = {
					enable = true,
				},

				highlight = {
					enable = true,

					-- Disable specific languages
					-- disable = { "c", "rust" },

					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
}
