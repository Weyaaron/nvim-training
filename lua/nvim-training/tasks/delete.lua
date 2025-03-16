local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local Delete = {}

Delete.__index = Delete
setmetatable(Delete, { __index = Task })
Delete.metadata = { autocmd = "", desc = "", instructions = "", tags = { "deletion" } }

function Delete:new()
	local base = Task:new()
	setmetatable(base, Delete)
	base.target_text = ""
	return base
end
function Delete:deactivate()
	return self.target_text == self:read_register()
end

function Delete:delete_f(line, f_movement)
	local function _inner_update()
		self.cursor_target = utility.do_f_preparation(line, f_movement, self.target_char)
		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		if current_cursor_pos[2] < self.cursor_target[2] then
			self.target_text = utility.extract_text_left_to_right(line, current_cursor_pos[2], self.cursor_target[2])
		else
			self.target_text = utility.extract_text_right_to_left(line, self.cursor_target[2], current_cursor_pos[2])
		end
	end
	vim.schedule_wrap(_inner_update)()
end

function Delete:delete_with_word_movement(line, word_movement)
	local function _inner_update()
		--Todo: Fix/implement this?!
		utility.set_buffer_to_rectangle_with_line(line)

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], 20 })

		current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		local new_x_pos = word_movement(line, current_cursor_pos[2], self.counter)
		self.cursor_target = { current_cursor_pos[1], new_x_pos }
		utility.construct_highlight(current_cursor_pos[1], self.cursor_target[2], 1)

		self.target_text = line:sub(current_cursor_pos[2] + 1, self.cursor_target[2])

		utility.construct_word_hls_forwards(self.counter)
		utility.construct_highlight(current_cursor_pos[1], self.cursor_target[2], 1)
	end
	vim.schedule_wrap(_inner_update)()
end
return Delete
