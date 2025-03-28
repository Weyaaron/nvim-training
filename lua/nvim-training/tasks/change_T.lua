local Change = require("nvim-training.tasks.change")
local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local ChangeT = {}
ChangeT.__index = ChangeT
setmetatable(ChangeT, { __index = Change })
ChangeT.metadata = {
	autocmd = "InsertLeave",
	desc = "Change text using T",
	instructions = "",
	tags = utility.flatten({ tag_index.cchange, tag_index.T }),
	input_template = "cT<target_char>x<esc>",
}

function ChangeT:new()
	local base = Change:new()
	setmetatable(base, { __index = ChangeT })
	base.line_text_after_change = ""
	return base
end

function ChangeT:activate()
	local line = utility.construct_char_line(self.target_char, self.cursor_center_pos - 10)
	self:change_f(line, movements.T)
end

function ChangeT:instructions()
	return "Change the text in between the cursor and the char right to '"
		.. self.target_char
		.. "' into '"
		.. self.text_to_be_inserted
		.. "' and exit insert mode."
end

return ChangeT
