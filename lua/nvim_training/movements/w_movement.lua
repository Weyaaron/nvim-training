local base_movement = require("lua/nvim_training/movements/base_movement")
local wMovement = base_movement:new()
wMovement.__index = wMovement
wMovement.base_args = { offset = 0 }

function wMovement:_execute_calculation()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local cursor_node = self.buffer_as_list:traverse_to_line_char(cursor_pos[1], cursor_pos[2])
	local target_node = cursor_node:traverse_n(self.offset)
	return { target_node.line_index, target_node.start_index }
end

return wMovement
