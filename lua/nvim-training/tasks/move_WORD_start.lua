local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local movements = require("nvim-training.movements")

local MoveWORDStart = {}
MoveWORDStart.__index = MoveWORDStart
setmetatable(MoveWORDStart, { __index = Move })
MoveWORDStart.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move Back to the start of 'WORDS'.",
	instructions = "",
	tags = "movement, word, horizontal",
}

function MoveWORDStart:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveWORDStart })
	return base
end
function MoveWORDStart:activate()
	local function _inner_update()
		local line = utility.construct_WORDS_line()
		utility.set_buffer_to_rectangle_with_line(line)

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], 55 })
		self.cursor_target = movements.WORD_start(self.counter)
		utility.construct_highlight(current_cursor_pos[1], self.cursor_target[2], 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveWORDStart:instructions()
	return "Move 'Back' to the beginning of the " .. self.counter .. " 'WORD'."
end

return MoveWORDStart
