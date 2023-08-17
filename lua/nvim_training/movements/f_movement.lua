local linemovement = require("lua/nvim_training/movements/line_movement")
local fMovement = linemovement:new()
fMovement.__index = fMovement

fMovement.base_args = { target_char = "" }

function fMovement:_execute_calculation()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local cursor_pos_x = cursor_pos[1]
	local cursor_pos_y = cursor_pos[2]
	local y_target = 0
	local max_line_len = #self.current_line
	for i = cursor_pos_y + 2, max_line_len, 1 do
		local current_char = string.sub(self.current_line, i, i)
		if current_char == self.target_char then
			y_target = i
			break
		end
	end
	return { cursor_pos_x, y_target - 1 }
end

return fMovement
