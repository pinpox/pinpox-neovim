{
  description = "pinpox's portable neovim";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let

      # to work with older version of flakes
      # lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      # version = builtins.substring 0 8 lastModifiedDate;

      # System types to support.
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

    in
    {

      # Provide some binary packages for selected system types.
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};

          extraEnv = pkgs.buildEnv {
            name = "lsp-servers";
            paths = with pkgs; [
              shellcheck

              typst
              stix-two
              typstfmt
              tinymist
              # typst-lsp

              harper
              zig
              zls
              nil
              nixd
              pyright # LSP python
              nodePackages.yaml-language-server # LSP yaml
              vscode-extensions.golang.go # Golang snippets
              nodePackages.bash-language-server
              gopls # LSP go
              terraform-ls # LSP terraform
              # terraform # TODO add options to enable/disable large packages like terraform
              libgccjit # Needed for treesitter
              # sumneko-lua-language-server # Lua language server
              cargo
              rustc
              rustfmt
              rust-analyzer
              ltex-ls
            ];
          };

          neovim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (
            pkgs.neovimUtils.makeNeovimConfig {
              wrapRc = true;
              luaRcContent = /* lua */ ''

                  -- Bootstrap lazy.nvim
                  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
                  vim.opt.rtp:prepend(lazypath)
                  vim.g.mapleader = " "
                  vim.g.maplocalleader = "\\"

                  -- global lua table to acces nixpkgs plugin paths
                  plugin_dirs = {}
                  plugin_dirs["tokyonight-nvim"] = "${pkgs.vimPlugins.tokyonight-nvim}"
                  plugin_dirs["zk-nvim"] = "${pkgs.vimPlugins.zk-nvim}"

                  -- require("tokyonight")
                  require("plugins.zk-nvim")

                  -- Setup lazy.nvim
                  require("lazy").setup({
                    -- don't automatically check for plugin updates, we use nix for that here
                    checker = { enabled = false },
                  })

                 -- local utils = require('utils')

                 -- require('config.general') -- General options, should stay first!
                 -- require('config.pinpox-colors')
                 -- require('config.appearance')
                 -- require('config.treesitter')
                 -- require('config.lsp')
                 -- require('config.devicons')
                 -- require('config.cmp')
                 -- require('config.which-key')
                 -- require('config.bufferline') -- https://github.com/akinsho/bufferline.nvim/issues/271
                 -- -- require('config.cokeline') -- https://github.com/akinsho/bufferline.nvim/issues/271
                 -- require('config.lualine')
                 -- require('config.gitsigns')
                 -- require('config.zk')

              '';
              plugins = with pkgs.vimPlugins; [

                lazy-nvim

                #
                # oil-nvim
                #
                # zig-vim
                #
                # ccc-nvim
                # nvim-treesitter.withAllGrammars
                # playground # Treesitter playground
                #
                # zk-nvim
                # # vim-visual-increment
                # # vim-indent-object
                # # vim-markdown # Disabled because of https://github.com/plasticboy/vim-markdown/issues/461
                # # vim-vinegar
                # bufferline-nvim
                # # i3config-vim
                # # nvim-cokeline
                # nvim-fzf
                # fzf-lua
                # indent-blankline-nvim-lua
                # colorbuddy-nvim
                # BufOnly-vim
                # ansible-vim
                # base16-vim
                # committia-vim
                # gitsigns-nvim
                # gotests-vim
                # haskell-vim
                # lualine-nvim
                # nvim-lspconfig
                # vim-jsonnet
                #
                # cmp-nvim-lsp
                # cmp-buffer
                # cmp-path
                # cmp-calc
                # cmp-emoji
                # cmp-nvim-lua
                # cmp-spell
                # # cmp-cmdline -- use wilder-nvim instead
                # nvim-cmp
                # luasnip
                # cmp_luasnip
                # friendly-snippets
                #
                # # nvim-colorizer-lua
                # nvim-highlight-colors
                # nvim-web-devicons
                # plenary-nvim
                # # tabular
                # vim-autoformat
                # vim-better-whitespace
                # vim-devicons
                # vim-easy-align
                # vim-eunuch
                # # vim-go # TODO https://github.com/NixOS/nixpkgs/pull/167912
                # vim-gutentags
                # vim-illuminate
                # which-key-nvim
                # vim-nix
                # vim-repeat
                # typst-vim
                # vim-sandwich
                # vim-table-mode
                # vim-terraform
                # vim-textobj-user
                # vim-gnupg
                # # vim-vsnip
                # # vim-vsnip-integ
                # wilder-nvim
                # diffview-nvim
              ];
            }
          );

          nvim-appname = "nvim-pinpox";

        in
        {
          pinpox-neovim = pkgs.writeShellScriptBin "nvim" ''
            set -efux
            unset VIMINIT
            export PATH=${extraEnv}/bin:${neovim}/bin:$PATH
            export NVIM_APPNAME=${nvim-appname}
            exec nvim --cmd "set rtp^=${./nvim}" "$@"
          '';
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.pinpox-neovim}/bin/nvim";
        };
      });
    };
}
