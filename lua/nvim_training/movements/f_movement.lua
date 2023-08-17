local linemovement = require("lua/nvim_training/movements/line_movement")
local fMovement = linemovement:new()
fMovement.__index = fMovement

fMovement.base_args = {}

function fMovement:_execute_calculation()

	local possible_chars = {"a","e"}
	local target_char ="e" 
	--Todo: Move this code to task and choose char randomly
	

	local cursor_pos= vim.api.nvim_win_get_cursor(0)
	local cursor_pos_y = cursor_pos[2]
	local cursor_pos_x = cursor_pos[1]
	local y_offset = 0
	local max_line_len = #self.current_line
	for i = cursor_pos_y, max_line_len, 1 do
		local current_char = string.sub(self.current_line, i,i)
		if current_char == target_char then
			y_offset = i
			break
		end


	end
	return {cursor_pos_x, cursor_pos_y + y_offset}
end

return fMovement
