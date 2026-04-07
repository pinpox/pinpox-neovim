local servers = {
  ts_ls = {},
  pyright = {},
  gopls = {},
  bashls = {},
  yamlls = {},
  rust_analyzer = {},
  zls = {},
  tinymist = {},
  -- harper_ls = {},

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
        end,
      },
    },
  },

  zk = {},

  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
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
          library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },
}

-- Initialize all LSPs from the list above, using
-- their setup options + the capabilities set by blink.cmp
for server, config in pairs(servers) do
  config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end

-- Additional LSP-specific configs
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    -- Disable semantic token highlighting
    client.server_capabilities.semanticTokensProvider = nil

    -- Enable code lenses where supported (rendered as virtual lines in 0.12)
    if client.server_capabilities.codeLensProvider then
      vim.lsp.codelens.refresh({ bufnr = args.buf })
    end
  end,
})

-- update diagnostics while typing
vim.diagnostic.config({ update_in_insert = true })
