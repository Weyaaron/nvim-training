local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local internal_config = require("nvim-training.internal_config")
local movements = require("nvim-training.movements")
local user_config = require("nvim-training.user_config")

local Delete_f = {}
Delete_f.__index = Delete_f
setmetatable(Delete_f, { __index = Delete })
Delete_f.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move using f.",
	instructions = "Move using f.",
	tags = "movement, f, horizontal",
}

function Delete_f:new()
	local base = Delete:new()
	setmetatable(base, { __index = Delete_f })
	self.target_char = utility.calculate_target_char()
	return base
end

function Delete_f:activate()
	local function _inner_update()
		local target_index = math.random(25, 30)
		local line = utility.construct_char_line(self.target_char, target_index)
		utility.set_buffer_to_rectangle_with_line(line)

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], target_index })
		local target_pos = movements.f(self.target_char)
		self.cursor_target = { cursor_pos[1], movements.f(self.target_char) }

		self.target_text = line:sub(target_index + 1, target_pos)
	end
	vim.schedule_wrap(_inner_update)()
end

function Delete_f:instructions()
	return "Delete to the char '" .. self.target_char .. "' using f."
end

return Delete_f
