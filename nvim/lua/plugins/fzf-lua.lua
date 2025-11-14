return {
	{
		dir = pluginpaths .. "/fzf-lua",
		name = "fzf-lua",
		dependencies = { { dir = pluginpaths .. "/nvim-web-devicons" } },
		config = function()
			require("nvim-web-devicons").setup({
				-- globally enable default icons (default to false)
				-- will get overriden by `get_icons` option
				default = true,
			})

			local function setup_fzf()
				require("fzf-lua").setup({
					grep = {
						actions = {
							["alt-q"] = {
								fn = require("fzf-lua").actions.file_edit_or_qf,
								prefix = "select-all+",
							},
						},
					},
					winopts = {
						hls = {
							normal = 'Normal',
							border = 'Normal',
							title = 'Title',
							help_normal = 'Normal',
							help_border = 'Normal',
							preview_normal = 'Normal',
							preview_border = 'Normal',
							preview_title = 'Title',
							cursor = 'Cursor',
							cursorline = 'CursorLine',
							cursorlinenr = 'CursorLineNr',
							search = 'Search',
							scrollborder_e = 'Normal',
							scrollborder_f = 'Normal',
						},
					},
					fzf_colors = {
						['fg']          = { 'fg', 'Normal' },
						['bg']          = { 'bg', 'Normal' },
						['hl']          = { 'fg', 'Search' },
						['fg+']         = { 'fg', 'CursorLine' },
						['bg+']         = { 'bg', 'CursorLine' },
						['hl+']         = { 'fg', 'Search' },
						['info']        = { 'fg', 'Comment' },
						['border']      = { 'fg', 'Normal' },
						['gutter']      = { 'bg', 'Normal' },
						['prompt']      = { 'fg', 'Keyword' },
						['pointer']     = { 'fg', 'Keyword' },
						['marker']      = { 'fg', 'Keyword' },
						['spinner']     = { 'fg', 'Comment' },
						['header']      = { 'fg', 'Comment' },
					},
				})
			end

			-- Make the setup function globally accessible for theme reloading
			_G.reload_fzf_theme = setup_fzf

			-- Initial setup
			setup_fzf()
		end,
	},
}
