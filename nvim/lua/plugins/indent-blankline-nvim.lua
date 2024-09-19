	return {
		{
			dir = plugin_dirs["indent-blankline-nvim"],
			name = "indent-blankline-nvim",
			config = function()
				vim.g.indentLine_char = '│'
				require("ibl").setup {
					-- space_char_blankline = " ",
					-- show_current_context = true,
					-- show_current_context_start = false,
				}
			end,
		},
	}
