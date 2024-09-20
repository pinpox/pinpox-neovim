return {
	{
		name = "lualine-nvim",
		dir = pluginpaths .. "/lualine.nvim" ,
		-- dependencies = {
			--	{ dir = pluginpaths  .. "/fzf-lua"      },
			-- },
			config = function()

				-- +-------------------------------------------------+
				-- | A | B | C                             X | Y | Z |
				-- +-------------------------------------------------+

				vim.opt.rtp:prepend(luamodpath)
				local nixcolors = require('nixcolors')

				local nixcolors_theme = {
					normal = {
						a = { fg = nixcolors.Black, bg = nixcolors.Blue },
						b = { fg = nixcolors.Black, bg = nixcolors.BrightWhite},
						c = { bg = nixcolors.BrightBlack },
					},

					insert = { a = { fg = nixcolors.Black, bg = nixcolors.Blue } },
					visual = { a = { fg = nixcolors.Black, bg = nixcolors.Cyan } },
					replace = { a = { fg = nixcolors.Black, bg = nixcolors.Red } },

					inactive = {
						a = { fg = nixcolors.White, bg = nixcolors.Black },
						b = { fg = nixcolors.White, bg = nixcolors.Black },
						c = { fg = nixcolors.White },
					},
				}

				local conditions = {
					buffer_not_empty = function()
						return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
					end,
					hide_in_width = function()
						return vim.fn.winwidth(0) > 80
					end,
					check_git_workspace = function()
						local filepath = vim.fn.expand('%:p:h')
						local gitdir = vim.fn.finddir('.git', filepath .. ';')
						return gitdir and #gitdir > 0 and #gitdir < #filepath
					end
				}

				local mode_colors = {
					n      = nixcolors.Blue,
					i      = nixcolors.Green,
					v      = nixcolors.Magenta,
					[''] = nixcolors.Magenta,
					V      = nixcolors.BrightMagenta,
					c      = nixcolors.Magenta,
					no     = nixcolors.Red,
					s      = nixcolors.Yellow,
					S      = nixcolors.BrightYellow,
					[''] = nixcolors.BrightYellow,
					ic     = nixcolors.Yellow,
					R      = nixcolors.Cyan,
					Rv     = nixcolors.BrightCyan,
					cv     = nixcolors.Red,
					ce     = nixcolors.Red,
					r      = nixcolors.Cyan,
					rm     = nixcolors.Cyan,
					['r?'] = nixcolors.Cyan,
					['!']  = nixcolors.Red,
					t      = nixcolors.Red,
				}

				require("lualine").setup {

					options = {
						theme = nixcolors_theme,
						component_separators = '',
						section_separators = { left = '', right = '' },
						-- section_separators = { left = '', right = '' },
					},


					tabline = {
						lualine_a = {
							{
								"buffers",
								-- separator = { right = '' , left = '' },
								separator = { right = ' ' , left = ' ' },
								right_padding = 2,
								symbols = { alternate_file = "" },
							},
						},
					},

					sections = {
						lualine_a = {
							{
								'mode',
								color = function()
									return { bg = mode_colors[vim.fn.mode()], gui = 'bold' }
								end,
							},
						},
						-- },

						lualine_b = { {'branch', icon = ''} },

						lualine_c ={ {
							-- filesize component
							function()
								local function format_file_size(file)
									local size = vim.fn.getfsize(file)
									if size <= 0 then return '' end
									local sufixes = {'b', 'k', 'm', 'g'}
									local i = 1
									while size > 1024 do
										size = size / 1024
										i = i + 1
									end
									return string.format('%.1f%s', size, sufixes[i])
								end
								local file = vim.fn.expand('%:p')
								if string.len(file) == 0 then return '' end
								return format_file_size(file)
							end,
							condition = conditions.buffer_not_empty,
							color = { fg = nixcolors.White, gui = 'italic'},
						},
						{
							'filename',
							condition = conditions.buffer_not_empty,
							color = {fg = nixcolors.Magenta, gui = 'italic'},
						},
						-- {'location'},
						-- {
							--	'progress',
							--	color = {fg = nixcolors.White, gui = 'bold'},
							-- },
							{
								'diagnostics',
								sources = {'nvim_diagnostic'},
								symbols = {error = ' ', warn = ' ', info= ' '},
								color_error = nixcolors.Red,
								color_warn = nixcolors.Yellow,
								color_info = nixcolors.Cyan,
							},
							-- Insert mid section. You can make any number of sections in neovim :)
							-- for lualine it's any number gretter then 2
							{function() return '%=' end},
							{
								-- Lsp server name .
								function ()
									local msg = 'No Active Lsp'
									local buf_ft = vim.api.nvim_buf_get_option(0,'filetype')
									local clients = vim.lsp.get_active_clients()
									if next(clients) == nil then return msg end
									for _, client in ipairs(clients) do
										local filetypes = client.config.filetypes
										if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
											return client.name
										end
									end
									return msg
								end,
								icon = ' LSP:',
								color = {fg = nixcolors.BrightCyan, gui = 'bold'}
							},
						},

						lualine_x = {

							-- Add components to right sections
							{
								'o:encoding', -- option component same as &encoding in viml
								upper = true, -- I'm not sure why it's uper case either ;)
								condition = conditions.hide_in_width,
								color = {fg = nixcolors.Green, gui = 'bold'}
							},

							{
								'fileformat',
								upper = true,
								icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
								color = {fg = nixcolors.Green, gui='bold'},
							},


							{
								'diff',
								-- Is it me or the symbol for modified us really weird
								symbols = {added= ' ', modified= ' ', removed= ' '},
								color_added = nixcolors.Green,
								color_modified = nixcolors.BrightYellow,
								color_removed = nixcolors.Red,
								condition = conditions.hide_in_width
							},

						},
					},
				}
			end,
		},
	}



