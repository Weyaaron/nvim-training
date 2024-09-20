local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local movements = require("nvim-training.movements")
local Move_t = {}

Move_t.__index = Move_t
setmetatable(Move_t, { __index = Move })
Move_t.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move using t.",
	instructions = "",
	tags = "movement, t, horizontal",
}

function Move_t:new()
	local base = Move:new()
	setmetatable(base, { __index = Move_t })
	base.target_char = utility.calculate_target_char()
	return base
end

function Move_t:activate()
	local function _inner_update()
		local cursor_target_pos = math.random(20, 40)
		local line = utility.construct_char_line(self.target_char, cursor_target_pos + 10)
		utility.set_buffer_to_rectangle_with_line(line)

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], cursor_target_pos })

		self.cursor_target = movements.t(self.target_char)
	end
	vim.schedule_wrap(_inner_update)()
end


function Move_t:instructions()
	return "Move next to the char '" .. self.target_char .. "' using t."
end

return Move_t
