local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local Change = {}

Change.__index = Change
setmetatable(Change, { __index = Task })
Change.__metadata = { autocmd = "", desc = "", instructions = "" }

function Change:new()
	local base = Task:new()
	setmetatable(base, Change)

	self.cursor_target = { 0, 0 }
	self.target_text = "x"
	self.target_line = -1
	return base
end
function Change:deactivate()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	if type(self.cursor_target) == "number" then
		print("Target has to be type table, current value is " .. tostring(self.cursor_target))
	end
	local cursor_at_right_place = cursor_pos[1] == self.cursor_target[1] and cursor_pos[2] == self.cursor_target[2]
	local line = utility.get_line(cursor_pos[1])
	local line_is_same = line == self.target_line
	local text_left_of_cursor = line:sub((cursor_pos[2] + 1) - (#self.base_text - 1), cursor_pos[2] + 1)
	return cursor_at_right_place and (text_left_of_cursor == self.base_text) and line_is_same
end

return Change
