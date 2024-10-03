local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")

local MoveCharsRight = {}
setmetatable(MoveCharsRight, { __index = Move })
MoveCharsRight.__index = MoveCharsRight

function MoveCharsRight:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveCharsRight })
	return base
end

MoveCharsRight.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move right charwise.",
	instructions = "",
	tags = "movement, l, horizontal",
}

function MoveCharsRight:activate()
	local function _inner_update()
		local line = utility.construct_words_line()
		utility.set_buffer_to_rectangle_with_line(line)
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		local new_y = cursor_pos[2] + self.counter
		self.cursor_target = { cursor_pos[1], new_y }
		utility.construct_highlight(cursor_pos[1], new_y, 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveCharsRight:instructions()
	return "Move " .. self.counter .. " char(s) right."
end
return MoveCharsRight
