local base_movement = require("lua/nvim_training/movements/base_movement")
local SearchMovement = base_movement:new()
local utility = require("lua.nvim_training.utility")
SearchMovement.__index = SearchMovement

SearchMovement.base_args = { offset = 0 }

local linked_list = require("nvim_training.linked_list")
function SearchMovement:_execute_calculation()
	local cursor_node = self.buffer_as_list:traverse(linked_list.traverse_to_cursor)

	local target_node = cursor_node:traverse(linked_list.traverse_n(self.offset))
	print(target_node.content)
	return { target_node.line_index, target_node.start_index - 1 }
end

return SearchMovement
