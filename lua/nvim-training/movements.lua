local utility = require("nvim-training.utility")
local movements = {}

function movements.end_of_line()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_current_line()
	local target = #line - 1
	if target == cursor_pos[2] then
		--This prevents starting in the last column
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], cursor_pos[2] - 1 })
		target = target - 1
	end

	return { cursor_pos[1], target }
end
return movements
