-- luacheck: globals vim

local SearchTask = require("lua.nvim_training.tasks.base_movement"):new()
SearchTask.base_args = { autocmds = { "CursorMoved" }, tags = { "buffer" }, help = " (Tip: Use /target)" }

local utility = require("nvim_training.utility")

function SearchTask:setup()
	self:load_from_json("permutation.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)
	self.buffer_as_list = utility.construct_linked_list()

	local offset = math.random(2, 15)
	local cursor_position = vim.api.nvim_win_get_cursor(0)
	local cursor_node = self.buffer_as_list:traverse_to_line_char(cursor_position[1], cursor_position[2])

	local content_word = cursor_node:traverse_n(offset).content
	self.desc = "Move to '" .. content_word .. "'."

	local target_node = cursor_node:search(content_word)
	self.new_buffer_coordinates = { target_node.line_index, target_node.start_index - 1 }
	self.highlight =
		utility.create_highlight(target_node.line_index - 1, target_node.start_index - 1, #target_node.content)
end

return SearchTask
