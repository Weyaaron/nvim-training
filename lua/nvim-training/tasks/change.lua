local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local logging = require("nvim-training.logging")
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
	local line_is_same = current_line == self.line_text_after_change
	local text_left_of_cursor =
		current_line:sub((cursor_pos[2] + 1) - (#self.text_to_be_inserted - 1), cursor_pos[2] + 1)
	-- Todo: Turn into log
	-- print(
	-- 	line,
	-- 	"--",
	-- 	self.line_text_after_change,
	-- 	line_is_same,
	-- 	cursor_pos[2],
	-- 	self.cursor_target[2],
	-- 	text_left_of_cursor == self.text_to_be_inserted
	-- )
	logging.log("F:", {
		tt = self.line_text_after_change,
		ct = current_line,
		lt = #self.line_text_after_change,
		lc = #current_line,
	})
	return current_line == self.line_text_after_change
end

function Change:change_with_right_f_motion(line, f_motion)
	local function _inner_update()
		utility.set_buffer_to_rectangle_with_line(line)

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], self.cursor_center_pos })
		current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		local new_x_pos = f_motion(line, current_cursor_pos[2], self.target_char)

		self.line_text_after_change = line:sub(0, current_cursor_pos[2])
			.. self.text_to_be_inserted
			.. line:sub(new_x_pos + 1, #line)

		self.cursor_target = { current_cursor_pos[1], new_x_pos }

		utility.construct_highlight(current_cursor_pos[1], new_x_pos - 1, 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function Change:change_with_left_f_motion(line, f_motion)
	local function _inner_update()
		utility.set_buffer_to_rectangle_with_line(line)

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], self.cursor_center_pos })
		current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		local new_x_pos = f_motion(line, current_cursor_pos[2], self.target_char)

		self.line_text_after_change = line:sub(0, new_x_pos - 1)
			.. self.text_to_be_inserted
			.. line:sub(current_cursor_pos[2] + 1, #line)

		self.cursor_target = { current_cursor_pos[1], new_x_pos }

		utility.construct_highlight(current_cursor_pos[1], new_x_pos - 1, 1)
	end
	vim.schedule_wrap(_inner_update)()
end

return Change
