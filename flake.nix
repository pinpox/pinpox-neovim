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
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; config.allowUnfree = true; });

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
              cargo
              gopls # LSP go
              typescript-language-server
              harper
              libgccjit # Needed for treesitter
              fzf
              lua-language-server
              nil
              nixd
              bash-language-server
              yaml-language-server # LSP yaml
              pyright # LSP python
              rust-analyzer
              rustc
              rustfmt
              shellcheck
              stylua # lua formatter
              tinymist
              vscode-extensions.golang.go # Golang snippets
              # zig # TODO: broken in nixpkgs (Zig build failure)
              # zls # TODO: broken in nixpkgs (Zig build failure)
            ];
          };

          neovim = { waylandSupport ? pkgs.stdenv.hostPlatform.isLinux }:
            let
              # Eager plugins: loaded at startup via wrapNeovim's standard
              # mechanism (added directly to runtimepath via --cmd "set rtp^=...").
              eagerPlugins = with pkgs.vimPlugins; [
                lz-n  # the lazy-loader itself; must be eager
                blink-cmp
                ccc-nvim
                colorbuddy-nvim
                committia-vim
                conform-nvim
                diffview-nvim
                friendly-snippets
                fzf-lua
                gitsigns-nvim
                lualine-nvim
                luasnip
                nvim-highlight-colors
                nvim-lspconfig
                nvim-pqf
                nvim-treesitter.withAllGrammars
                nvim-web-devicons
                oil-nvim
                outline-nvim
                plenary-nvim
                vim-better-whitespace
                vim-devicons
                vim-easy-align
                vim-eunuch
                vim-gnupg
                vim-illuminate
                vim-repeat
                vim-sandwich
                vim-table-mode
                vim-textobj-user
                which-key-nvim
                wilder-nvim
                zk-nvim
              ];

              # Lazy plugins: installed as optional packages under
              # pack/pinpox/opt/<pname>. lz.n calls :packadd on them when their
              # trigger fires.
              lazyPlugins = with pkgs.vimPlugins; [
                hlchunk-nvim
                incline-nvim
                # Language-specific filetype plugins
                gotests-vim
                haskell-vim
                vim-go
                vim-jsonnet
                vim-nix
                zig-vim
              ];

              # Build a packpath dir containing only the opt/ packages.
              # The eager plugins are already on the rtp via wrapNeovim, so they
              # don't need to be in this linkfarm.
              optPackDir = pkgs.linkFarm "pinpox-nvim-opt" (
                map (p: {
                  name = "pack/pinpox/opt/${p.pname}";
                  path = p;
                }) lazyPlugins
              );

            in

            pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
              inherit waylandSupport;
              wrapRc = true;
              luaRcContent = ''
                  vim.g.mapleader = " "
                  vim.g.maplocalleader = "\\"

                  -- Make pack/pinpox/opt/* discoverable by :packadd (used by lz.n)
                  vim.opt.packpath:prepend("${optPackDir}")

                  -- Pass flake's ./nvim path so lua modules under it can be required
                  luamodpath = "${./nvim}"

                  require('options') -- General options, should stay first!
                  require('plugins') -- Eager setup + lz.n registration

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

              plugins = map (p: { plugin = p; }) eagerPlugins;
            };

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
