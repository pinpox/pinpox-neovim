local M = {}

-- Default configuration
M.config = {
	on_dark = function()
		print("Theme was switched to dark")
	end,
	on_light = function()
		print("Theme was switched to light")
	end,
}

-- Get current system theme via dbus
function M.get_current_theme()
	local result = vim.system({
		'dbus-send',
		'--session',
		'--print-reply',
		'--dest=org.freedesktop.portal.Desktop',
		'/org/freedesktop/portal/desktop',
		'org.freedesktop.portal.Settings.Read',
		'string:org.freedesktop.appearance',
		'string:color-scheme'
	}, { text = true }):wait()

	if result.code == 0 then
		-- Parse the result: uint32 0 = no preference, 1 = dark, 2 = light
		local value = result.stdout:match("uint32%s+(%d+)")
		if value == "1" then
			return "dark"
		elseif value == "2" then
			return "light"
		end
	end

	return "dark" -- Default to dark if detection fails
end

-- Apply theme by calling the appropriate callback
function M.apply_theme(theme)
	if theme == "dark" then
		M.config.on_dark()
	elseif theme == "light" then
		M.config.on_light()
	end
end

-- Start monitoring dbus for theme changes
function M.start_monitor()
	vim.system({
		'dbus-monitor',
		'--session',
		"interface='org.freedesktop.portal.Settings',member='SettingChanged'"
	}, {
		stdout = function(err, data)
			if data and data:match('color%-scheme') then
				-- Schedule the theme check in the main event loop
				vim.schedule(function()
					local new_theme = M.get_current_theme()
					M.apply_theme(new_theme)
				end)
			end
		end,
		stderr = function(err, data)
			-- Silently ignore stderr to avoid noise
		end
	})
end

-- Setup function with optional user configuration
function M.setup(opts)
	-- Merge user config with defaults
	if opts then
		M.config = vim.tbl_deep_extend("force", M.config, opts)
	end

	-- Apply initial theme
	local initial_theme = M.get_current_theme()
	M.apply_theme(initial_theme)

	-- Start monitoring for changes
	M.start_monitor()
end

return M
