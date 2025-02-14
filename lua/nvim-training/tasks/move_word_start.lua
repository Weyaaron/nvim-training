local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local MoveWordStart = {}
MoveWordStart.__index = MoveWordStart
setmetatable(MoveWordStart, { __index = Move })
MoveWordStart.metadata = {
	autocmd = "CursorMoved",
	desc = "Move back to the start of 'words'.",
	instructions = "",
	tags = utility.flatten({ tag_index.movement, tag_index.word_start }),
}

function MoveWordStart:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveWordStart })
	return base
end
function MoveWordStart:activate()
	local function _inner_update()
		local line = utility.construct_WORDS_line()
		self.cursor_target = utility.do_word_preparation(line, movements.word_start, self.counter, 55)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveWordStart:instructions()
	return "Move 'back' to the start of the " .. self.counter .. " 'word'."
end

return MoveWordStart
