local M = {}

-- Dark theme colors (original)
M.dark = {
	Black         = "#24273a",
	BrightBlack   = "#5b6078",
	White         = "#cad3f5",
	BrightWhite   = "#747c9e",
	Red           = "#ed8796",
	BrightRed     = "#ff5370",
	Yellow        = "#eed49f",
	BrightYellow  = "#fab387",
	Green         = "#a6da95",
	BrightGreen   = "#68f288",
	Cyan          = "#8bd5ca",
	BrightCyan    = "#aee2da",
	Blue          = "#8aadf4",
	BrightBlue    = "#74c7ec",
	Magenta       = "#cba6f7",
	BrightMagenta = "#f5bde6",
}

-- Light theme colors
M.light = {
	Black         = "#eff1f5",
	BrightBlack   = "#bcc0cc",
	White         = "#4c4f69",
	BrightWhite   = "#5c5f77",
	Red           = "#d20f39",
	BrightRed     = "#e64553",
	Yellow        = "#df8e1d",
	BrightYellow  = "#fe8019",
	Green         = "#40a02b",
	BrightGreen   = "#66a80f",
	Cyan          = "#179299",
	BrightCyan    = "#04a5e5",
	Blue          = "#1e66f5",
	BrightBlue    = "#7287fd",
	Magenta       = "#8839ef",
	BrightMagenta = "#ea76cb",
}

-- Function to get colors based on background
function M.get_colors()
	if vim.o.background == "light" then
		return M.light
	else
		return M.dark
	end
end

-- Set default colors (maintains backward compatibility)
local colors = M.get_colors()
for k, v in pairs(colors) do
	M[k] = v
end

return M
