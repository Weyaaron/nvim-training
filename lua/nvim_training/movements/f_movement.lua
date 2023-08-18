local base_movement = require("lua/nvim_training/movements/base_movement")
local fMovement = base_movement:new()
local utility = require("lua.nvim_training.utility")
fMovement.__index = fMovement

fMovement.base_args = { target_char = "" }

function fMovement:_execute_calculation()
	local cursor_node = self.buffer_as_list:traverse(utility.traverse_to_cursor)

	local function traverse_to_char(input_node)
		local search_result = utility.search_for_char_in_word(input_node.content, self.target_char)
		return not (search_result == -1)
	end

	local final_node = cursor_node:traverse(traverse_to_char)
	local char_offset_in_word = utility.search_for_char_in_word(final_node.content, self.target_char)

	--Todo: Evaluate the -2 and fix it
	return { final_node.line_index, final_node.start_index + char_offset_in_word - 2 }
end

return fMovement
