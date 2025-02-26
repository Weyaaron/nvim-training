local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local MoveWordEnd = {}
MoveWordEnd.__index = MoveWordEnd
setmetatable(MoveWordEnd, { __index = Move })
MoveWordEnd.metadata = {
	autocmd = "CursorMoved",
	desc = "Move to the end of words.",
	instructions = "Move to the end of the current 'word'.",
	tags = utility.flatten({ tag_index.movement, tag_index.word_end }),
	input_template = "<counter>e",
}

function MoveWordEnd:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveWordEnd })
	return base
end
function MoveWordEnd:activate()
	local function _inner_update()
		local line = utility.construct_words_line()
		self.cursor_target = utility.do_word_preparation(line, movements.word_end, self.counter, math.random(1, 10))
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveWordEnd:instructions()
	return "Move to the end of " .. self.counter .. " 'words'."
end
return MoveWordEnd
