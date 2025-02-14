local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local movements = require("nvim-training.movements")

local MoveWORDStart = {}
MoveWORDStart.__index = MoveWORDStart
setmetatable(MoveWORDStart, { __index = Move })
MoveWORDStart.metadata = {
	autocmd = "CursorMoved",
	desc = "Move Back to the start of 'WORDS'.",
	instructions = "",
	tags = { "movement", "word", "horizontal" },
	input_template = "<counter>W",
}

function MoveWORDStart:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveWORDStart })
	return base
end
function MoveWORDStart:activate()
	local function _inner_update()
		local line = utility.construct_WORDS_line()
		self.cursor_target = utility.do_word_preparation(line, movements.WORD_start, self.counter, 55)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveWORDStart:instructions()
	return "Move 'Back' to the start of the " .. self.counter .. " 'WORD'."
end

return MoveWORDStart
