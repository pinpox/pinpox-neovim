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
            ];
          };

          neovim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (
            pkgs.neovimUtils.makeNeovimConfig {
              wrapRc = true;
              luaRcContent = ''
                require("testmodule")
                local utils = require('utils')
              '';
              plugins =  with pkgs.vimPlugins; [rose-pine];
              # extraLuaPackages = ps: [ (ps.callPackage ./lua-tiktoken.nix { }) ];
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
