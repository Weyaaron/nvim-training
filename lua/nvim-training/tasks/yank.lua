local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")

local Yank = {}
Yank.__index = Yank
setmetatable(Yank, { __index = Task })
Yank.metadata = { autocmd = "", desc = "", instructions = "", tags = { "yank", "register" } }

function Yank:new()
	local base = Task:new()
	setmetatable(base, Yank)
	return base
end
function Yank:deactivate()
	return self.target_text == self:read_register()
end

function Yank:yank_f(line, f_movement)
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

return Yank
