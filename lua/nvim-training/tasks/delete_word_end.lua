local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local DeleteWordEnd = {}
DeleteWordEnd.__index = DeleteWordEnd
setmetatable(DeleteWordEnd, { __index = Delete })
DeleteWordEnd.metadata = {
	autocmd = "TextChanged",
	desc = "Delete using 'e'.",
	instructions = "",
	tags = utility.flatten({ tag_index.word, "e", "deletion" }),
	input_template = "<target_register>d<counter>e",
}

function DeleteWordEnd:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteWordEnd })

	return base
end

function DeleteWordEnd:activate()
	local line = utility.construct_words_line()
	self:delete_with_word_movement(line, movements.word_end)
end

function DeleteWordEnd:instructions()
	return "Delete to the end of " .. self.counter .. " word(s)."
end
return DeleteWordEnd
