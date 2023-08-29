-- luacheck: globals vim

local eTask = require("nvim_training.tasks.base_movement"):new()
eTask.base_args = {
	autocmds = { "CursorMoved" },
	tags = { "movement", "relative", "word_based" },
	help = " (Tip: Use e)",
	min_level = 3,
	description = "Move to the end of words."
}
local utility = require("nvim_training.utility")

function eTask:setup()
	self:load_from_json("permutation.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)
	self.buffer_as_list = utility.construct_linked_list()
	local offset = math.random(3, 9)

	local current_cursor = vim.api.nvim_win_get_cursor(0)
	local right_cursor_bound = 7
	if current_cursor[2] > right_cursor_bound then
		local new_cursor_pos = math.random(right_cursor_bound)
		--	vim.api.nvim_win_set_cursor(0, { current_cursor[1], new_cursor_pos })
	end

	local cursor_position = vim.api.nvim_win_get_cursor(0)
	local cursor_node = self.buffer_as_list:traverse_to_line_char(cursor_position[1], cursor_position[2])

	local e_movement_result = cursor_node:e(offset, cursor_position[2])
	local target_node = e_movement_result.node
	offset = e_movement_result.offset
	self.instruction = "Move to the end of the " .. offset .. "th word. "
	self.new_buffer_coordinates = { target_node.line_index, target_node.end_index - 2 }

	self.highlight = utility.create_highlight(self.new_buffer_coordinates[1] - 1, self.new_buffer_coordinates[2], 1)
end

return eTask
