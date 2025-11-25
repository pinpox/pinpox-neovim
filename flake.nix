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
      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [
            (self: super: {
              # TODO https://github.com/NixOS/nixpkgs/pull/464773
              # Build lualine as a simple vim plugin instead of through luarocks to avoid rockspec hash mismatch
              vimPlugins = super.vimPlugins // {
                lualine-nvim = super.vimUtils.buildVimPlugin {
                  pname = "lualine.nvim";
                  version = "unstable-2024-01-01";
                  src = super.fetchFromGitHub {
                    owner = "nvim-lualine";
                    repo = "lualine.nvim";
                    rev = "47f91c416daef12db467145e16bed5bbfe00add8"; # From PR #464773
                    hash = "sha256-OpLZH+sL5cj2rcP5/T+jDOnuxd1QWLHCt2RzloffZOA=";
                  };
                  meta = {
                    homepage = "https://github.com/nvim-lualine/lualine.nvim";
                    description = "A blazing fast and easy to configure Neovim statusline";
                  };
                };
              };
            })
          ];
        }
      );

    in
    {

      # Provide some binary packages for selected system types.
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};

          # Extra packages that are needed for certain plugins
          extraEnv = pkgs.buildEnv {
            name = "lsp-servers";
            paths = with pkgs; [
              # terraform
              cargo
              gopls # LSP go
              typescript-language-server
              harper
              libgccjit # Needed for treesitter
              fzf
              lua-language-server
              nil
              nixd
              nodePackages.bash-language-server
              nodePackages.yaml-language-server # LSP yaml
              pyright # LSP python
              rust-analyzer
              rustc
              rustfmt
              shellcheck
              stix-two
              stylua # lua formatter
              terraform-ls # LSP terraform
              tinymist
              vscode-extensions.golang.go # Golang snippets
              zig
              zls
            ];
          };

          neovim = { waylandSupport ? pkgs.stdenv.hostPlatform.isLinux }:
            let
              plugins = with pkgs.vimPlugins; [
                lazy-nvim
                blink-cmp

                # vim-autoformat #replaced with conform-nvim (testing)
                oxocarbon-nvim
                modus-themes-nvim
                # base16-vim
                ccc-nvim
                # nvim-cmp
                # cmp-buffer
                # cmp-calc
                # cmp-emoji
                # cmp-nvim-lsp
                # cmp-nvim-lua
                # cmp-path
                # cmp-spell
                # cmp_luasnip
                colorbuddy-nvim
                committia-vim
                conform-nvim
                diffview-nvim
                friendly-snippets
                fzf-lua
                gitsigns-nvim
                gotests-vim
                haskell-vim
                lualine-nvim
                luasnip
                nvim-highlight-colors
                nvim-lspconfig
                nvim-pqf
                nvim-treesitter.withAllGrammars
                nvim-web-devicons
                oil-nvim
                outline-nvim
                playground
                plenary-nvim
                vim-better-whitespace
                vim-devicons
                vim-easy-align
                vim-eunuch
                vim-gnupg
                vim-go
                # vim-gutentags
                vim-illuminate
                vim-jsonnet
                vim-nix
                vim-repeat
                vim-sandwich
                vim-table-mode
                vim-terraform
                vim-textobj-user
                which-key-nvim
                wilder-nvim
                zig-vim
                zk-nvim
            incline-nvim
              ];

              pluginpaths = pkgs.linkFarm "plugindirs" (
                map (x: {
                  name = x.pname;
                  path = x;
                }) plugins # We could just load *all* pkgs.vimPlugins here?
              );

            in

            pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (
              pkgs.neovimUtils.makeNeovimConfig {
                inherit waylandSupport;
                wrapRc = true;
                customLuaRC = ''
                  -- Bootstrap lazy.nvim
                  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
                  vim.opt.rtp:prepend(lazypath)
                  vim.g.mapleader = " "
                  vim.g.maplocalleader = "\\"

                  -- Access nixpkgs plugin paths
                  pluginpaths = "${pluginpaths}"

                  -- Pass flake's ./nvim path to allow adding it to rtp to load other lua files
                  luamodpath = "${./nvim}"

                  local utils = require("utils")
                  require('options') -- General options, should stay first!
                  require("lazy").setup("plugins") -- loads all plugins in plugins dir

                  -- Non-plugin related configs
                  require('waste')

                  -- Setup automatic theme switching
                  require('theme-sync').setup({
                      on_dark = function()
                          vim.opt.background = "dark"
                          if _G.reload_lualine_theme then
                              _G.reload_lualine_theme()
                          end
                          if _G.reload_fzf_theme then
                              _G.reload_fzf_theme()
                          end
                          print("Theme switched to dark")
                      end,
                      on_light = function()
                          vim.opt.background = "light"
                          if _G.reload_lualine_theme then
                              _G.reload_lualine_theme()
                          end
                          if _G.reload_fzf_theme then
                              _G.reload_fzf_theme()
                          end
                          print("Theme switched to light")
                      end,
                  })
                '';

                # We only load lazy-nvim here, so that the rest of the plugins
                # can be loaded from the plugin manager. This dirty hack allows
                # lazy-loading plugins to improve startup time by orders of magnitude.
                plugins = with pkgs.vimPlugins; [ lazy-nvim ];
              }
            );

          nvim-appname = "nvim-pinpox";

        in
        {

          # Vim plugins, added inside existing pkgs.vimPlugins
          # vimPlugins = super.vimPlugins // {
          #   nvim-fzf = super.callPackage ../packages/nvim-fzf { inputs = inputs; };
          #   nvim-cokeline = super.callPackage ../packages/nvim-cokeline { inputs = inputs; };
          # };

          # {
          #   pkgs,
          #   stdenv,
          #   fetchFromGitHub,
          #   lib,
          #   inputs,
          #   ...
          # }:
          # pkgs.vimUtils.buildVimPlugin {
          #   pname = "nvim-cokeline";
          #   version = "latest";
          #   src = inputs.nvim-cokeline;
          #
          #   meta = with lib; {
          #     description = "A Neovim bufferline for people with addictive personalities";
          #     homepage = "https://github.com/noib3/nvim-cokeline";
          #     license = licenses.mit;
          #     platforms = platforms.unix;
          #   };
          # }

          # {
          #   pkgs,
          #   stdenv,
          #   fetchFromGitHub,
          #   lib,
          #   inputs,
          #   ...
          # }:
          # {
          #   pkgs,
          #   stdenv,
          #   fetchFromGitHub,
          #   lib,
          #   inputs,
          #   ...
          # }:
          # pkgs.vimUtils.buildVimPlugin {
          #   pname = "nvim-fzf";
          #   version = "latest";
          #   src = inputs.nvim-fzf;
          #
          #   meta = with lib; {
          #     description = "A Lua API for using fzf in neovim";
          #     homepage = "https://github.com/vijaymarupudi/nvim-fzf";
          #     license = licenses.gpl3;
          #     platforms = platforms.unix;
          #   };
          # }
          #

          pinpox-neovim =
            let
              neovimPackage = neovim { };
            in
            (pkgs.writeShellScriptBin "nvim" ''
              set -efu
              unset VIMINIT
              export PATH=${extraEnv}/bin:${neovimPackage}/bin:$PATH
              export NVIM_APPNAME=${nvim-appname}
              exec nvim --cmd "set rtp^=${./nvim}" "$@"
            '') // {
              override = args:
                let
                  neovimPackageOverride = neovim args;
                in
                pkgs.writeShellScriptBin "nvim" ''
                  set -efu
                  unset VIMINIT
                  export PATH=${extraEnv}/bin:${neovimPackageOverride}/bin:$PATH
                  export NVIM_APPNAME=${nvim-appname}
                  exec nvim --cmd "set rtp^=${./nvim}" "$@"
                '';
            };
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
