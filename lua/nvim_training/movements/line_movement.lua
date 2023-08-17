local movement = require("lua/nvim_training/movements/base_movement")
local LineMovement = movement:new()
LineMovement.__index = LineMovement

LineMovement.base_args = {}

function LineMovement:_prepare_calculation()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)[1] - 1
	local new_buffer_lines = vim.api.nvim_buf_get_lines(0, cursor_pos, cursor_pos + 1, false)
	self.current_line = new_buffer_lines[1]
end

return LineMovement
