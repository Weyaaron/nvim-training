-- luacheck: globals vim

local Task = require("nvim_training.task")
local utility = require("nvim_training.utility")
local PlaceMarkTask = Task:new()
PlaceMarkTask.base_args = { chars = { "a", "b", "c", "d", "x", "y" }, tags = { "mark" } }

-- Apparently, there is no autocmd for mark placed? Therefore, this is placed on halt until a
-- solution has been found.

function PlaceMarkTask:prepare()
	self:load_from_json("one_word_per_line.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)
	self:teardown_all_marks()

	self.current_mark_name = self.chars[math.random(1, #self.chars)]
	self.desc = "Place the mark " .. self.current_mark_name
end

function PlaceMarkTask:completed()
	local cursor_position = vim.api.nvim_win_get_cursor(0)[1]
	local comparison = cursor_position == self.target_line
	return comparison
end

function PlaceMarkTask:failed()
	return not self:completed()
end

function PlaceMarkTask:teardown() end
function PlaceMarkTask:teardown_all_marks() end

return PlaceMarkTask
