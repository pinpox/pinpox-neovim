# pinpox' neovim

My neovim configuration, bundled as standalone nix flake.

Try it out with:

```sh
nix run 'github:pinpox/pinpox-neovim'
```

The configuration makes use of [lazy.nvim](https://github.com/folke/lazy.nvim)
in combination with plugins from [nixpkgs](https://github.com/nixos/nixpkgs) to
provide a stateless setup, which can be run anywhere. It integrates lazy instead
of adding plugins directly via nix, to allow lazy-loading of plugins, provide
organized configuration and keep startup times fast.
