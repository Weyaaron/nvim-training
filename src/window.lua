local utility = require("src.utility")

local Window = {}
Window.__index = Window

function Window:new(width, height, row, col)
	local base = { win_width = width, win_height = height, win_row = row, win_col = col }
	setmetatable(base, { __index = self })

	base:display()
	return base
end

function Window:display()
	self.nvim_buf = vim.api.nvim_create_buf(false, true) -- create new emtpy buffer

	vim.api.nvim_buf_set_option(self.nvim_buf, "bufhidden", "wipe")

	-- set some options
	local opts = {
		style = "minimal",
		relative = "editor",
		anchor = "NW",
		width = self.win_width,
		height = self.win_height,
		row = self.win_row,
		col = self.win_col,
		focusable = false,
	}

	self.nvim_win = vim.api.nvim_open_win(self.nvim_buf, true, opts)
end

function Window:update_window_text(new_text)
	local text_as_lines = utility.split_str(new_text)
	vim.api.nvim_buf_set_lines(self.nvim_buf, 0, -1, false, text_as_lines)
end

return Window
