local utility = require("nvim-training.utility")
local Change = require("nvim-training.tasks.change")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")
local Changet = {}

Changet.__index = Changet
setmetatable(Changet, { __index = Change })
Changet.metadata = {
	autocmd = "InsertLeave",
	desc = "Change text using f",
	instructions = "",
	tags = utility.flatten({ tag_index.change, tag_index.t }),
}

function Changet:new()
	local base = Change:new()
	setmetatable(base, { __index = Changet })
	base.text_to_be_inserted = "x"
	base.line_text_after_change = ""
	return base
end

function Changet:activate()
	local line = utility.construct_char_line(self.target_char, self.cursor_center_pos + 10)
	self:change_f(line, movements.t)
end

function Changet:instructions()
	return "Change the text in between the cursor and the char next to '"
		.. self.target_char
		.. "' into '"
		.. self.text_to_be_inserted
		.. "' and exit insert mode."
end

return Changet
