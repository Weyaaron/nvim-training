-- luacheck: globals vim

local utility = require("nvim_training.utility")
local Task = require("nvim_training.task")

local MoveRelativeLineTask = Task:new()
MoveRelativeLineTask.base_args = { tags = { "movement", "relative" }, autocmds = { "CursorMoved" } }

function MoveRelativeLineTask:prepare()
	self:load_from_json("one_word_per_line.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)

	self.previous_line = 0

	self.current_offset = utility.draw_random_number_with_sign(2, 9)
	self.previous_line = vim.api.nvim_win_get_cursor(0)[1]

	while self.current_offset + self.previous_line < 0 do
		self.current_offset = utility.draw_random_number_with_sign(2, 9)
	end

	self.desc = "Move " .. tostring(self.current_offset) .. " lines relative to your cursor."

	local line_for_highlight = self.previous_line + self.current_offset - 1
	self.highlight = utility.create_highlight(line_for_highlight, 0, -1)
end

function MoveRelativeLineTask:completed()
	return vim.api.nvim_win_get_cursor(0)[1] == self.previous_line + self.current_offset
end

function MoveRelativeLineTask:failed()
	return not self:completed()
end

function MoveRelativeLineTask:teardown()
	utility.clear_highlight(self.highlight)
end

return MoveRelativeLineTask
