require("blink.cmp").setup({
  -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
  -- 'super-tab' for mappings similar to vscode (tab to accept)
  -- 'enter' for enter to accept
  -- 'none' for no mappings
  --
  -- All presets have the following mappings:
  -- C-space: Open menu or open docs if already open
  -- C-n/C-p or Up/Down: Select next/previous item
  -- C-e: Hide menu
  -- C-k: Toggle signature help (if signature.enabled = true)
  --
  -- See :h blink-cmp-config-keymap for defining your own keymap
  keymap = { preset = "super-tab" },

  completion = {
    -- (Default) Only show the documentation popup when manually triggered
    documentation = { auto_show = true },
    -- Display a preview of the selected item on the current line
    ghost_text = { enabled = true },
  },

  -- Default list of enabled providers defined so that you can extend it
  -- elsewhere in your config, without redefining it, due to `opts_extend`
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },

  -- Experimental signature help
  -- signature = { enabled = true },

  -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
  fuzzy = { implementation = "prefer_rust_with_warning" },
})
