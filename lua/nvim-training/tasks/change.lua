local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local Change = {}

Change.__index = Change
setmetatable(Change, { __index = Task })
Change.metadata = { autocmd = "", desc = "", instructions = "", tags = { "change" } }

function Change:new()
	local base = Task:new()
	setmetatable(base, Change)
	self.cursor_target = { 0, 0 }
	self.line_text_after_change = ""
	self.text_to_be_inserted = "x"
	return base
end
function Change:deactivate()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	if type(self.cursor_target) == "number" then
		print("Target has to be type table, current value is " .. tostring(self.cursor_target))
	end
	local current_line = utility.get_line(cursor_pos[1])
	utility.update_debug_state({ curr_line = current_line, target_line = self.line_text_after_change })
	return current_line == self.line_text_after_change
end

function Change:change_f(line, f_movement)
	local function _inner_update()
		self.cursor_target = utility.do_f_preparation(line, f_movement, self.target_char)
		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)

		local text_between_positions = ""
		if current_cursor_pos[2] < self.cursor_target[2] then
			text_between_positions =
				utility.extract_text_left_to_right(line, current_cursor_pos[2], self.cursor_target[2])
		else
			text_between_positions =
				utility.extract_text_right_to_left(line, self.cursor_target[2], current_cursor_pos[2])
		end

		self.line_text_after_change = string.gsub(line, text_between_positions, self.text_to_be_inserted)
	end
	vim.schedule_wrap(_inner_update)()
end

return Change
