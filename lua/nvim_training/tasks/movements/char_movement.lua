-- luacheck: globals vim

local utility = require("nvim_training.utility")
local Task = require("nvim_training.task")

local MoveRelativeCharTask = Task:new()
MoveRelativeCharTask.base_args = { tags = { "movement", "relative" }, autocmds = { "CursorMoved" } }

function MoveRelativeCharTask:prepare()
	self:load_from_json("lorem_ipsum.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)

	local offset = utility.draw_random_number_with_sign(2, 9)

	local cursor_pos = vim.api.nvim_win_get_cursor(0)

	local current_char_index = cursor_pos[2]
	local current_line_index = cursor_pos[1]
	local current_line = vim.api.nvim_buf_get_lines(0, current_line_index, current_line_index + 1, false)
	local current_line_len = #current_line[1]
	while  true do
		offset = utility.draw_random_number_with_sign(2, 9)
		local left_bound = current_char_index + offset > 0
		local right_bound = current_char_index+ offset < current_line_len
		if left_bound and right_bound then
			print("broken")
			break
		end
	end

	self.desc = "Move " .. tostring(offset) .. " chars relative to your cursor."
	self.new_buffer_coordinates = { current_line_index, current_char_index + offset }

	self.highlight = utility.create_highlight(current_line_index-1, self.new_buffer_coordinates[2], 1)
end

function MoveRelativeCharTask:completed()
	local current_cursor = vim.api.nvim_win_get_cursor(0)
	local x_diff = current_cursor[1] - self.new_buffer_coordinates[1]
	local y_diff = current_cursor[2] - self.new_buffer_coordinates[2]
	return x_diff == 0 and y_diff == 0
end

function MoveRelativeCharTask:failed()
	return not self:completed()
end

function MoveRelativeCharTask:teardown()
	utility.clear_highlight(self.highlight)
end

return MoveRelativeCharTask
