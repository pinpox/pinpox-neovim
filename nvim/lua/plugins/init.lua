-- Plugin entry point. Replaces the previous lazy.nvim setup.
--
-- Eager plugins are already on the runtimepath via wrapNeovim (the flake
-- passes them to makeNeovimConfig.plugins). For each one, we just require
-- its config file, which calls setup() directly.
--
-- Lazy plugins live under pack/pinpox/opt/<name> and are registered with
-- lz.n, which calls :packadd when their trigger fires.

local eager = {
  "completion",
  "conform",
  "fzf-lua",
  "gitsigns",
  "lsp",
  "lualine",
  "nvim-highlight-colors",
  "oil",
  "other",
  "outline",
  "pqf",
  "which-key-nvim",
  "zk-nvim",
}

for _, name in ipairs(eager) do
  require("plugins." .. name)
end

require("lz.n").load({
  {
    "hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    after = function()
      local nixcolors = require("nixcolors")
      require("hlchunk").setup({
        line_num = {
          enable = true,
          style = nixcolors.Cyan,
        },
        indent = {
          enable = true,
          style = { vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui") },
        },
        chunk = {
          enable = true,
          style = {
            { fg = nixcolors.BrightWhite },
            { fg = nixcolors.BrightRed },
          },
        },
      })
    end,
  },
  {
    "incline.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("incline").setup()
    end,
  },

  -- Language-specific filetype plugins. No setup() calls needed; being on the
  -- runtimepath provides syntax/indent/ftplugin/commands for the relevant ft.
  { "vim-go",      ft = "go" },
  { "gotests-vim", ft = "go" },
  { "haskell-vim", ft = "haskell" },
  { "vim-jsonnet", ft = "jsonnet" },
  { "vim-nix",     ft = "nix" },
  { "zig.vim",     ft = "zig" },
})
