local ft_to_ext = {
	cpp = "cpp",
	c = "c",
	css = "css",
	go = "go",
	html = "html",
	java = "java",
	javascript = "js",
	lua = "lua",
	markdown = "md",
	python = "py",
	rust = "rs",
	xml = "xml",
	yaml = "yaml",
	nix = "nix",
}

local wastebin_url = "https://paste.0cx.de"

-- Gets selected text, if range was specified
local function get_visual_selection()
	local range_start = vim.fn.getpos("'<")
	local range_end = vim.fn.getpos("'>")
	local num_lines = math.abs(range_end[2] - range_start[2]) + 1
	local lines = vim.api.nvim_buf_get_lines(0, range_start[2] - 1, range_end[2], false)
	lines[1] = string.sub(lines[1], range_start[3], -1)
	if num_lines == 1 then
		lines[num_lines] = string.sub(lines[num_lines], 1, range_end[3] - range_start[3] + 1)
	else
		lines[num_lines] = string.sub(lines[num_lines], 1, range_end[3])
	end
	return table.concat(lines, "\n")
end

-- Gets full buffer text (no range specified)
local function get_buffer_text()
	local content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
	return table.concat(content, "\n")
end

local function send_to_wastebin(params)
	local text = ""

	if params.range > 0 then
		text = get_visual_selection()
	else
		text = get_buffer_text()
	end

	local body = vim.fn.json_encode({ text = text, extension = ft_to_ext[vim.bo.filetype] })

	local obj = vim.system(
		{ "curl", "-s", "-H", "Content-Type: application/json", "--data-binary", "@-", wastebin_url },
		{ text = true, stdin = body }
	):wait()

	-- Decode response URL
	local response = vim.fn.json_decode(obj.stdout)
	local purl = (wastebin_url .. response.path)
	print(purl)

	-- Copy url to clipboard
	vim.system( { "wl-copy"}, { text = true, stdin = purl }):wait()
end

vim.api.nvim_create_user_command("Waste", send_to_wastebin, { desc = "Send to Wastebin", nargs = "*", range = true })

