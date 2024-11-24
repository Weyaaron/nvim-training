local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local DeleteWord = {}
DeleteWord.__index = DeleteWord
setmetatable(DeleteWord, { __index = Delete })
DeleteWord.metadata = {
	autocmd = "TextChanged",
	desc = "Delete multiple words.",
	instructions = "",
	tags = utility.flatten({ tag_index.deletion, tag_index.word }),
}

function DeleteWord:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteWord })
	return base
end

function DeleteWord:activate()
	local line = utility.construct_words_line()
	self:delete_with_word_movement(line, movements.words)
end

function DeleteWord:instructions()
	return "Delete "
		.. self.counter
		.. " word(s)"
		.. utility.construct_register_description(self.target_register)
		.. "."
end
return DeleteWord
