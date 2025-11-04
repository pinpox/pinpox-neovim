return {
	{
		dir = pluginpaths .. "/nvim-lspconfig",

		dependencies = { { dir = pluginpaths .. "/blink.cmp" } },

		name = "nvim-lspconfig",

		opts = {
			servers = {
				ts_ls = {},
				pyright = {},
				gopls = {},
				terraformls = {},
				bashls = {},
				yamlls = {},
				rust_analyzer = {},
				zls = {},
				tinymist = {},
				-- typst_lsp = {},
				-- harper_ls = {},

				-- Spell/Grammar checking, e.g for markdown files
				ltex_plus = {
					autostart = false,
					settings = {
						ltex = {
							language = "de-DE",
							enabled = { "bib", "typst" },
						},
					},
				},

				nixd = {
					cmd = { "nixd" },
					settings = {
						nixd = {
							nixpkgs = {
								expr = "import <nixpkgs> { }",
							},
							formatting = {
								command = { "nixfmt" },
							},
							options = {
								nixos = {
									expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.k-on.options',
								},
								home_manager = {
									expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."ruixi@k-on".options',
								},
							},
						},
					},
				},

				jsonls = {
					cmd = { "json-languageserver", "--stdio" },
					commands = {
						Format = {
							function()
								-- USE: :%!jq .
								-- vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
								-- vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
								-- vim.lsp.buf.formatting_sync(nil, 100)
							end,
						},
					},
				},

				zk = {
					-- local configs = require("lspconfig/configs")
					-- configs.zk = {
					-- 	default_config = {
					-- 		cmd = { "zk", "lsp", "--log", "/tmp/zk-lsp.log" },
					-- 		filetypes = { "markdown" },
					-- 		root_dir = function()
					-- 			return vim.loop.cwd()
					-- 		end,
					-- 		settings = {},
					-- 	},
					-- }
				},

				lua_ls = {
					settings = {
						Lua = {
							runtime = {
								-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
								version = "LuaJIT",
							},
							diagnostics = {
								-- Get the language server to recognize the `vim` global

								globals = {
									-- AwesomeWM
									"awesome",
									"client",
									"screen",
									"root",
									-- Vim
									"vim",
								},
							},
							workspace = {
								-- Make the server aware of Neovim runtime files
								library = vim.api.nvim_get_runtime_file("", true),

								-- library = {
								--     [vim.fn.expand('$VIMRUNTIME/lua')] = true,
								--     [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,

								--     -- TODO find a way to add the nix store path dynamically.
								--     -- This will break on update!
								--     [vim.fn.expand('/nix/store/3xx4k57zz8l3hvzqd4v3v0ffgspp3pan-awesome-4.3/share/awesome/lib')] = true,
								-- },
							},
							-- Do not send telemetry data containing a randomized but unique identifier
							telemetry = {
								enable = false,
							},
						},
					},
				},
			},
		},

		config = function(_, opts)

			-- Initialize all LSPs from the list above, using
			-- their setup options + the capabilities set by blink.cmp
			for server, config in pairs(opts.servers) do
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				vim.lsp.config(server, config)
				vim.lsp.enable(server)
			end

			-- Additional LSP-specific configs

			-- Adds `:LtexLangChangeLanguage de` command to allow changing language for a
			-- document. Defaults to en
			vim.api.nvim_create_user_command("LtexLangChangeLanguage", function(data)
				local language = data.fargs[1]
				local bufnr = vim.api.nvim_get_current_buf()
				local client = vim.lsp.get_clients({ bufnr = bufnr, name = "ltex" })
				if #client == 0 then
					vim.notify("No ltex client attached")
				else
					client = client[1]
					client.config.settings = {
						ltex = {
							language = language,
						},
					}
					client.notify("workspace/didChangeConfiguration", client.config.settings)
					vim.notify("Language changed to " .. language)
				end
			end, {
				nargs = 1,
				force = true,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					client.server_capabilities.semanticTokensProvider = nil
				end,
			})

			-- lspconfig updates while typing
			vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { update_in_insert = true })
		end,
	},
}
