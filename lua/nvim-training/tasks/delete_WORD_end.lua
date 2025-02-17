local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local DeleteWORDEnd = {}
DeleteWORDEnd.__index = DeleteWORDEnd
setmetatable(DeleteWORDEnd, { __index = Delete })
DeleteWORDEnd.metadata = {
	autocmd = "TextChanged",
	desc = "Delete using 'E'.",
	instructions = "",
	tags = utility.flatten({ tag_index.WORD, "E", "deletion" }),
}

function DeleteWORDEnd:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteWORDEnd })

	return base
end

function DeleteWORDEnd:activate()
	local line = utility.construct_WORDS_line()
	self:delete_with_word_movement(line, movements.WORD_end)
end

function DeleteWORDEnd:instructions()
	return "Delete to the end of " .. self.counter .. " WORDS(s)."
end
return DeleteWORDEnd
