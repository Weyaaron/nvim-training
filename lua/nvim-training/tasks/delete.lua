local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local Delete = {}

Delete.__index = Delete
setmetatable(Delete, { __index = Task })
Delete.__metadata = { autocmd = "", desc = "", instructions = "", tags = { "deletion" } }

function Delete:new()
	local base = Task:new()
	setmetatable(base, Delete)
	base.target_text = ""
	return base
end
function Delete:deactivate()
	local register_content = vim.fn.getreg('"')
	register_content = utility.split_str(register_content, "\n")[1]
	return self.target_text == register_content
end

function Delete:prep_for_f_movement(line, f_movement)
	utility.set_buffer_to_rectangle_with_line(line)

	local current_cursor_pos = vim.api.nvim_win_get_cursor(0)

	vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], self.cursor_center_pos })
	local new_x_pos = f_movement(line, current_cursor_pos[2], self.target_char)
	return new_x_pos
end
function Delete:delete_with_left_f_movement(line, f_movement)
	local function _inner_update()
		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		local new_x_pos = self:prep_for_f_movement(line, f_movement)
		new_x_pos = new_x_pos - 1

		local str_index_offset = 1
		self.cursor_target = { current_cursor_pos[1], new_x_pos }

		current_cursor_pos = vim.api.nvim_win_get_cursor(0)

		self.target_text = line:sub(self.cursor_target[2] + str_index_offset, current_cursor_pos[2])
		--Todo: Add hl that works for the region
		utility.construct_highlight(current_cursor_pos[1], self.cursor_target[2], 1)
	end

	vim.schedule_wrap(_inner_update)()
end
function Delete:delete_with_right_f_movement(line, f_movement)
	local function _inner_update()
		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		local new_x_pos = self:prep_for_f_movement(line, f_movement)

		new_x_pos = new_x_pos - 1

		local str_index_offset = 1
		self.cursor_target = { current_cursor_pos[1], new_x_pos }

		current_cursor_pos = vim.api.nvim_win_get_cursor(0)

		self.target_text = line:sub(current_cursor_pos[2] + str_index_offset, self.cursor_target[2] + str_index_offset)
		--Todo: Add hl that works for the region
		utility.construct_highlight(current_cursor_pos[1], self.cursor_target[2], 1)
	end

	vim.schedule_wrap(_inner_update)()
end
return Delete
