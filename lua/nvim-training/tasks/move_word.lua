local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local MoveWord = {}
MoveWord.__index = MoveWord
setmetatable(MoveWord, { __index = Move })
MoveWord.metadata = {
	autocmd = "CursorMoved",
	desc = "Move multiple words.",
	instructions = "",
	tags = utility.flatten({ tag_index.movement, tag_index.word }),
	input_template = "<counter>w",
}

function MoveWord:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveWord })

	return base
end

function MoveWord:activate()
	local function _inner_update()
		local line = utility.construct_words_line()
		self.cursor_target = utility.do_word_preparation(line, movements.words, self.counter, 20)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveWord:instructions()
	return "Move " .. self.counter .. " word(s)."
end

return MoveWord
