return {
	-- TODO: check out https://github.com/kdheepak/lazygit.nvim

{
  dir = pluginpaths .. "/incline.nvim",
  name = "incline-nvim",
  config = function()
    require('incline').setup()
  end,
  -- Optional: Lazy load Incline
  event = 'VeryLazy',
}
}
