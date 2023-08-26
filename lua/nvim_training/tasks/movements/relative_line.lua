-- luacheck: globals vim

local utility = require("nvim_training.utility")
local Task = require("nvim_training.task")

local MoveRelativeLineTask = Task:new()
MoveRelativeLineTask.base_args =
	{ tags = { "movement", "relative" }, autocmds = { "CursorMoved" }, help = " (Tip: Use j,k)" }

function MoveRelativeLineTask:setup()
	self:load_from_json("one_word_per_line.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)

	local left_bound = 2
	local right_bound = 9

	self.current_offset = utility.draw_random_number_with_sign(left_bound, right_bound)
	self.previous_line = vim.api.nvim_win_get_cursor(0)[1]
	--The -1 corrects for the offset -1 in line_for_highlight
	while self.current_offset + self.previous_line < 1 do
		self.current_offset = utility.draw_random_number_with_sign(left_bound, right_bound)
	end

	self.desc = "Move " .. tostring(self.current_offset) .. " lines."

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
