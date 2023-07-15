local window_management = {}

local window_table = {}
local utility = require("src.utility")

function window_management.open_window(width, height, row, col)
	local window_buffer = vim.api.nvim_create_buf(false, true) -- create new emtpy buffer

	vim.api.nvim_buf_set_option(window_buffer, "bufhidden", "wipe")

	-- set some options
	local opts = {
		style = "minimal",
		relative = "editor",
		anchor = "NW",
		width = width,
		height = height,
		row = row,
		col = col,
		focusable = false,
	}

	-- and finally create it with buffer attached
	local win = vim.api.nvim_open_win(window_buffer, true, opts)

	window_table[#window_table + 1] = { buffer = window_buffer, window = win }
	return #window_table
end

function window_management.update_window_text(window_index, new_text)
	local text_as_lines = utility.split_str(new_text)
	vim.api.nvim_buf_set_lines(window_table[window_index]["buffer"], 0, -1, false, text_as_lines)
end

return window_management
