local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local movements = require("nvim-training.movements")

local MoveF = {}
MoveF.__index = MoveF
setmetatable(MoveF, { __index = Move })
MoveF.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move using F.",
	instructions = "",
	tags = "movement, F, horizontal",
}

function MoveF:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveF })
	base.target_char = utility.calculate_target_char()
	return base
end

function MoveF:activate()
	local function _inner_update()
		local target_cursor_pos = math.random(20, 40)
		local line = utility.construct_char_line(self.target_char, target_cursor_pos - 10)
		utility.set_buffer_to_rectangle_with_line(line)

		local cursor_pos = vim.api.nvim_win_get_cursor(0)

		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], target_cursor_pos })
		self.cursor_target = movements.F(self.target_char)
		utility.construct_highlight(self.cursor_target[1], self.cursor_target[2], 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveF:instructions()
	return "Move to the char '" .. self.target_char .. "' using F."
end

return MoveF
