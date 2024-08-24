local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local movements = require("nvim-training.movements")

local MoveT = {}
MoveT.__index = MoveT
setmetatable(MoveT, { __index = Move })
MoveT.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move using T.",
	instructions = "",
	tags = "movement, T, horizontal",
}

function MoveT:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveT })
	base.target_char = utility.calculate_target_char()
	return base
end

function MoveT:activate()
	local function _inner_update()
		local cursor_target_pos = 30
		local line = utility.construct_char_line(self.target_char, cursor_target_pos)
		utility.set_buffer_to_rectangle_with_line(line)
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], cursor_target_pos + math.random(5, 10) })

		self.cursor_target = { cursor_pos[1], movements.T(self.target_char) }
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveT:instructions()
	return "Move next to the char '" .. self.target_char .. "' using T."
end

return MoveT
