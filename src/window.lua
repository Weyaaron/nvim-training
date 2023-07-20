local utility = require("src.utility")

local Window = {}

function Window:new(width, height, row, col)
	local newObj = { win_width = width, win_height = height, win_row = row, win_col = col }
	self.__index = self
	setmetatable(newObj, self)

	newObj:display()
	return newObj
end

function Window:display()
	self.nvim_buf = vim.api.nvim_create_buf(false, true) -- create new emtpy buffer

	vim.api.nvim_buf_set_option(self.nvim_buf, "bufhidden", "wipe")

	-- set some options
	local opts = {
		style = "minimal",
		relative = "editor",
		anchor = "NW",
		width = self.win_height,
		height = self.win_height,
		row = self.win_row,
		col = self.win_col,
		focusable = false,
	}

	-- and finally create it with buffer attached
	self.nvim_win = vim.api.nvim_open_win(self.nvim_buf, true, opts)
end

function Window:update_window_text(new_text)
	local text_as_lines = utility.split_str(new_text)
	vim.api.nvim_buf_set_lines(self.nvim_buf, 0, -1, false, text_as_lines)
end

return Window
