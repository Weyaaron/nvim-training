local linemovement = require("lua/nvim_training/movements/line_movement")
local tMovement = linemovement:new()
tMovement.__index = tMovement

tMovement.base_args = { target_char = "" }

function tMovement:_execute_calculation()

	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local cursor_pos_x = cursor_pos[1]
	local cursor_pos_y = cursor_pos[2]
	local y_target = 0
	local max_line_len = #self.current_line
	for i = cursor_pos_y + 2, max_line_len, 1 do
		local current_char = string.sub(self.current_line, i, i)
		if current_char == self.target_char then
			y_target = i - 1
			break
		end
	end

	return { cursor_pos_x, y_target - 1 }
end

return tMovement
