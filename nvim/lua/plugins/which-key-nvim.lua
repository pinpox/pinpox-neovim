--
-- TODO: move mappings to corresponding plugins where possible
--
return {
	{
		dir = pluginpaths .. "/which-key.nvim" ,
		name = "which-key-nvim",
		config = function()
			local wk = require("which-key")

			wk.setup({
				plugins = {
					registers = true, -- Show registers and macros on " and @
					spelling = {
						    enabled = true, -- z= to select spelling suggestions
						    suggestions = 5,
						},
					},
				})

				-----------------
				-- Normal mode --
				-----------------
				wk.add({

					-- Cycle buffers
					{ "<C-n>",     ":bnext<CR>",                               desc = "Next buffer" },
					{ "<C-p>",     ":bprev<CR>",                               desc = "Previous buffer" },
					{ "<leader>1", ":LualineBuffersJump 1<CR>", hidden = true, desc = "Go to buffer 1" },
					{ "<leader>2", ":LualineBuffersJump 2<CR>", hidden = true, desc = "Go to buffer 2" },
					{ "<leader>3", ":LualineBuffersJump 3<CR>", hidden = true, desc = "Go to buffer 3" },
					{ "<leader>4", ":LualineBuffersJump 4<CR>", hidden = true, desc = "Go to buffer 4" },
					{ "<leader>5", ":LualineBuffersJump 5<CR>", hidden = true, desc = "Go to buffer 5" },
					{ "<leader>6", ":LualineBuffersJump 6<CR>", hidden = true, desc = "Go to buffer 6" },
					{ "<leader>7", ":LualineBuffersJump 7<CR>", hidden = true, desc = "Go to buffer 7" },
					{ "<leader>8", ":LualineBuffersJump 8<CR>", hidden = true, desc = "Go to buffer 8" },
					{ "<leader>9", ":LualineBuffersJump 9<CR>", hidden = true, desc = "Go to buffer 9" },


					-- LSP
					{ "<leader>c", group = "Code (LSP)" },
					{ "<leader>cS", ":FzfLua lsp_document_symbols<CR>",      desc = "Symbols" },
					{ "<leader>ca", ":FzfLua lsp_code_actions<CR>",          desc = "Code actions" },
					{ "<leader>cd", ":lua vim.diagnostic.open_float() <CR>", desc = "Line diagnostics" },
					{ "<leader>cf", ':lua require"conform".format()<CR>',    desc = "Autoformat" },
					{ "<leader>ci", ":lua vim.lsp.buf.hover()<CR>",          desc = "Hover information" },
					{ "<leader>cs", ":lua vim.lsp.buf.signature_help()<CR>", desc = "Signature" },

					-- FZF
					{ "<leader>F", ":FzfLua git_files<CR>",         desc = "Git files" },
					{ "<leader>f", ":FzfLua files<CR>",             desc = "Files" },
					{ "<leader>b", ":FzfLua buffers<CR>",           desc = "Buffers" },
					{ "<leader>q", ":FzfLua quickfix<CR>",          desc = "Quickfix" },
					{ "<leader>G", ":FzfLua live_grep<CR>",         desc = "Live Grep" },
					{ "<leader>r", ":lua vim.lsp.buf.rename()<CR>", desc = "Rename" },

					{ "<M-j>", "<cmd>cnext<CR>", desc = "Quickfix next" },
					{ "<M-k>", "<cmd>cprev<CR>", desc = "Quickfix previous" },

					-- Git
					{ "<leader>g", group = "Git" },
					{ "<leader>gR", ':lua require"gitsigns".reset_buffer()<CR>',    desc = "Reset buffer" },
					{ "<leader>gb", ':lua require"gitsigns".blame_line()<CR>',      desc = "Git Blame line" },
					{ "<leader>gp", ':lua require"gitsigns".preview_hunk()<CR>',    desc = "Preview hunk" },
					{ "<leader>gr", ':lua require"gitsigns".reset_hunk()<CR>',      desc = "Reset hunk" },
					{ "<leader>gs", ':lua require"gitsigns".stage_hunk()<CR>',      desc = "Stage hunk" },
					{ "<leader>gu", ':lua require"gitsigns".undo_stage_hunk()<CR>', desc = "Undo stage hunk" },

					-- Remap the arrow keys to nothing
					{ "<left>",  "<nop>", desc = "Nothing" },
					{ "<right>", "<nop>", desc = "Nothing" },
					{ "<up>",    "<nop>", desc = "Nothing" },
					{ "<down>",  "<nop>", desc = "Nothing" },

					-- Use Q for playing q macro
					{ "Q", "@q", desc = "Play q macro" },

					{ "g", group = "Goto" },
					{ "gD", ":lua vim.lsp.buf.declaration()<CR>",      desc = "Declaration" },
					{ "gd", ":lua vim.lsp.buf.definition()<CR>",       desc = "Definition" },
					{ "gi", ":lua vim.lsp.buf.implementation()<CR>",   desc = "Implementation" },
					{ "gj", ":lua vim.lsp.diagnostic.goto_next()<CR>", desc = "Next diagnostic" },
					{ "gk", ":lua vim.lsp.diagnostic.goto_prev()<CR>", desc = "Previuous diagnostic" },
					{ "gr", ":FzfLua lsp_references<CR>",              desc = "References" },
					{ "gt", ":lua vim.lsp.buf.type_definition()<CR>",  desc = "Type Definition" },

					{
						-- Switch ; and :
						mode = { "v", "n" },
						{ ":", ";", desc = "Switch ; and :", silent = false },
						{ ";", ":", desc = "Switch ; and :", silent = false },
					},

					{
						-----------------
						-- Visual mode --
						-----------------
						mode = { "v" },

						-- Move lines up and down
						{ "<C-j>", ":m '>+<CR>gv", desc = "Move line down",              silent = false },
						{ "<C-k>", ":m-2<CR>gv",   desc = "Move line up",                silent = false },

						{ "<C-a>", "g<C-a>",       desc = "Visual increment numbers",    silent = false },
						{ "<C-x>", "g<C-x>",       desc = "Visual decrement numbers",    silent = false },
						{ "g<C-a>", "<C-a>",       desc = "Increment numbers",           silent = false },
						{ "g<C-x>", "<C-x>",       desc = "Decrement numbers",           silent = false },

						-- Indent lines and reselect visual group
						{ "<", "<gv",              desc = "Reselect on indenting lines", silent = false },
						{ ">", ">gv",              desc = "Reselect on indenting lines", silent = false },
					},
				})
			end,
		},
	}
