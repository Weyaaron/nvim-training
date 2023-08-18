local movement = require("lua/nvim_training/movements/base_movement")
local ForwardMovement = movement:new()
ForwardMovement.__index = ForwardMovement

ForwardMovement.base_args = { jump_count = "" }

function ForwardMovement:_prepare_calculation()
	local current_cursor = vim.api.nvim_win_get_cursor(0)
	local buffer_length = vim.api.nvim_buf_line_count(0)
	local current_buffer_lines = vim.api.nvim_buf_get_lines(0, current_cursor[1] - 1, buffer_length, false)
	local current_cursor_line = ""
	for i, v in pairs(current_buffer_lines) do
		current_cursor_line = current_cursor_line .. v
	end
	local left_sub_str = string.sub(current_cursor_line, current_cursor[2], #current_cursor_line)

	self.right_str = left_sub_str
	local result = {}
end
function ForwardMovement:_execute_calculation()
	return { 10, 10 }
end

return ForwardMovement
