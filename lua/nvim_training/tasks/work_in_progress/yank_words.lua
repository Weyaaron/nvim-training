-- luacheck: globals vim

local Task = require("nvim_training.task")

local YankWordsTask = Task:new()
YankWordsTask.base_args = { autocmds = { "TextYankPost" }, tags = { "buffer" } }
local utility = require("nvim_training.utility")

function YankWordsTask:setup()
	--Yanking sets the textlock, this breaks most of this plugin.https://neovim.io/doc/user/eval.html#textlock
	self:load_from_json("permutation.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)

	local offset = math.random(2, 10)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local move_to_cursor = self.buffer_as_list:traverse_to_line_char(cursor_pos[1], cursor_pos[2])
	local movement_result = move_to_cursor:w(offset)
	self.desc = "Move " .. tostring(offset) .. " words relative to your cursor using w."
	self.new_buffer_coordinates = { movement_result.line_index, movement_result.end_index }

	self.highlight = utility.create_highlight(self.new_buffer_coordinates[1] - 1, self.new_buffer_coordinates[2], 1)
end

function YankWordsTask:completed()
	return true
end

function YankWordsTask:failed()
	return not self:completed()
end

function YankWordsTask:teardown()
	utility.clear_highlight(self.highlight)
end

return YankWordsTask
