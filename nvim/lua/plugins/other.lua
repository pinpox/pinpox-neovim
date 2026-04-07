-- Plugins that need no setup call — being on the runtimepath is enough.
-- They're listed in flake.nix's eagerPlugins and added to rtp by wrapNeovim.
--
-- This file used to enumerate them as lazy.nvim `dir = ` specs; that's no
-- longer needed. Kept as a placeholder so init.lua can require it without
-- a special case, and as documentation of what's intentionally setup-free.

require("illuminate").configure({
  under_cursor = false,
})
