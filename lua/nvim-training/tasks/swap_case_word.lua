local SwapCase = require("nvim-training.tasks.swap_case")
local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")

local tag_index = require("nvim-training.tag_index")

local SwapCaseWord = {}
SwapCaseWord.__index = SwapCaseWord
setmetatable(SwapCaseWord, { __index = SwapCase })
SwapCaseWord.metadata = {
	autocmd = "TextChanged",
	desc = "Swap the capitalisation of the next words.",
	instructions = "",
	tags = utility.flatten({ tag_index.case, tag_index.word }),
}

function SwapCaseWord:new()
	local base = SwapCase:new()
	setmetatable(base, SwapCaseWord)

	return base
end

function SwapCaseWord:activate()
	local line = utility.construct_words_line()
	self:swap_case_with_word_movement(line, movements.words)
end

function SwapCaseWord:instructions()
	return "Swap the capitalisation of the next " .. self.counter .. " word(s)."
end
return SwapCaseWord
