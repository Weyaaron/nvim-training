-- luacheck: globals vim

local MoveAbsoluteLineTask =require("lua.nvim_training.tasks.base_movement"):new()
local utility = require("nvim_training.utility")

MoveAbsoluteLineTask.base_args = { tags = { "movement", "line_based" }, autocmds = { "CursorMoved" } }

function MoveAbsoluteLineTask:prepare()
	self:load_from_json("one_word_per_line.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)

	local bounds = { 1, vim.api.nvim_buf_line_count(0) - 5 }

	self.target_line_index = math.random(bounds[1], bounds[2])
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	while current_line == self.target_line_index do
		self.target_line_index = math.random(bounds[1], bounds[2])
	end

	self.desc = "Move to line " .. tostring(self.target_line_index)
	self.highlight = utility.create_highlight(self.target_line_index - 1, 0, -1)

	self.new_buffer_coordinates = {self.target_line_index, 0}
end


return MoveAbsoluteLineTask
