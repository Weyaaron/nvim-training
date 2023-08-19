local Movements = {}


--Motions assume that one starts at the cursor
function Movements.w(input_node, cursor_x, cursor_y, custom_args)
	local target_node = input_node:traverse_n(custom_args.offset)
	return { target_node,target_node.line_index, target_node.start_index }
end
function Movements.test(input_node, cursor_x, cursor_y, custom_args)
	return { input_node, 5, 5 }
end
function Movements.e(input_node, cursor_x, cursor_y, custom_args)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local cursor_node = self.buffer_as_list:traverse_to_line_char(cursor_pos[1], cursor_pos[2])
	local target_node = cursor_node:traverse_n(self.offset)
	return { target_node.line_index, target_node.end_index - 2 }
end

function Movements.f(input_node, cursor_x, cursor_y, custom_args)
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

function Movements.search(input_node, cursor_x, cursor_y, custom_args)
	local cursor_position = vim.api.nvim_win_get_cursor(0)
	local cursor_node = self.buffer_as_list:traverse_to_line_char(cursor_position[1], cursor_position[2])

	local target_node = cursor_node:traverse_n(self.offset)

	return { target_node.line_index, target_node.start_index - 1 }
end

return Movements
