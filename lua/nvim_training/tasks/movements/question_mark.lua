
-- luacheck: globals vim

local QuestionMarkTask = require("nvim_training.tasks.base_movement"):new()
QuestionMarkTask.base_args = {
	autocmds = { "CursorMoved" },
	tags = { "absolute", "search" },
	help = " (Tip: Use ?target)",
	min_level = 5,
	description = "Search for a word backwards.",
}

local utility = require("nvim_training.utility")

function QuestionMarkTask:setup()
	self:load_from_json("permutation.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)
	self.buffer_as_list = utility.construct_linked_list()

	local offset = math.random(2, 15)
	local cursor_position = vim.api.nvim_win_get_cursor(0)

	if cursor_position[1] < 5 then
		vim.api.nvim_win_set_cursor(0, { math.random(3,7), cursor_position[2]})
	end

	cursor_position = vim.api.nvim_win_get_cursor(0)
	local cursor_node = self.buffer_as_list:traverse_to_line_char(cursor_position[1], cursor_position[2])

	local content_word = cursor_node:backtrack_n(offset).content
	self.instruction = "Move to '" .. content_word .. "'."

	local target_node = cursor_node:search_backward(content_word)
	self.new_buffer_coordinates = { target_node.line_index, target_node.start_index - 1 }
	self.highlight =
		utility.create_highlight(target_node.line_index - 1, target_node.start_index - 1, #target_node.content)
end

return QuestionMarkTask
