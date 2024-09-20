local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local internal_config = require("nvim-training.internal_config")
local movements = require("nvim-training.movements")
local user_config = require("nvim-training.user_config")
local Move_f = {}

Move_f.__index = Move_f
setmetatable(Move_f, { __index = Move })
Move_f.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move using f.",
	instructions = "Move using f.",
	tags = "movement, f, horizontal",
}

function Move_f:new()
	local base = Move:new()
	setmetatable(base, { __index = Move_f })
	base.target_char = utility.calculate_target_char()
	return base
end

function Move_f:activate()
	local function _inner_update()
		local cursor_target_pos = math.random(20, 40)
		local line = utility.construct_char_line(self.target_char, cursor_target_pos + 10)
		utility.set_buffer_to_rectangle_with_line(line)

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], cursor_target_pos })

		self.cursor_target = movements.f(self.target_char)

		utility.construct_highlight(self.cursor_target[1], self.cursor_target[2], 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function Move_f:instructions()
	return "Move to the char '" .. self.target_char .. "' using f."
end

return Move_f
