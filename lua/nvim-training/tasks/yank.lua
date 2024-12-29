local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local Yank = {}

Yank.__index = Yank
setmetatable(Yank, { __index = Task })
Yank.__metadata = { autocmd = "", desc = "", instructions = "" }

function Yank:new()
	local base = Task:new()
	setmetatable(base, Yank)
	base.chosen_register = '"'
	return base
end
function Yank:deactivate()
	local register_content = vim.fn.getreg(self.chosen_register)
	register_content = utility.split_str(register_content, "\n")[1]
	-- print("reg", #register_content, vim.inspect(register_content), "target", #self.target_text, self.target_text, "--")

	return self.target_text == register_content
end

function Yank:prep_for_f_movement(line, f_movement)
	utility.set_buffer_to_rectangle_with_line(line)

	local current_cursor_pos = vim.api.nvim_win_get_cursor(0)

	vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], self.cursor_center_pos })
	local new_x_pos = f_movement(line, current_cursor_pos[2], self.target_char)
	return new_x_pos
end

function Yank:yank_with_left_f_movement(line, f_movement)
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
function Yank:yank_with_right_f_movement(line, f_movement)
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

return Yank
