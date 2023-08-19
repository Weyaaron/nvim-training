local base_movement = require("lua/nvim_training/movements/base_movement")
local eMovement = base_movement:new()
eMovement.__index = eMovement
eMovement.base_args = { offset = 0 }

local utility = require("nvim_training.utility")
function eMovement:_execute_calculation()
	local cursor_node = self.buffer_as_list:traverse(utility.traverse_to_cursor)

	local target_node = cursor_node:traverse(utility.traverse_n(self.offset))
	print(target_node.content)
	return { target_node.line_index, target_node.start_index }
end

return eMovement
