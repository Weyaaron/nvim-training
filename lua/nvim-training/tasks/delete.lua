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
return Delete
