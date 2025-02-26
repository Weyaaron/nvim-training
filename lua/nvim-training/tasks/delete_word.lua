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
	input_template = "<target_register>d<counter>w",
}

function DeleteWord:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteWord })
	return base
end

function DeleteWord:activate()
	local function _inner_update()
		local line = utility.construct_words_line()
		self.cursor_target = utility.do_word_preparation(line, movements.words, self.counter, 20)
		self.target_text = utility.extract_text_from_coordinates(self.cursor_target)
	end
	vim.schedule_wrap(_inner_update)()
end

function DeleteWord:instructions()
	return "Delete "
		.. self.counter
		.. " word(s)"
		.. utility.construct_register_description(self.target_register)
		.. "."
end
return DeleteWord
