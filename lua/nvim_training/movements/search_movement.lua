local base_movement = require("lua/nvim_training/movements/base_movement")
local SearchMovement = base_movement:new()
SearchMovement.__index = SearchMovement

SearchMovement.base_args = { offset = 0 }

function SearchMovement:_execute_calculation()
	local cursor_position = vim.api.nvim_win_get_cursor(0)
	local cursor_node = self.buffer_as_list:traverse_to_line_char(cursor_position[1], cursor_position[2])

	local target_node = cursor_node:traverse_n(self.offset)

	print(target_node.content)
	return { target_node.line_index, target_node.start_index - 1 }
end

return SearchMovement
