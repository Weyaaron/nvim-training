local Change = require("nvim-training.tasks.change")
local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local Changef = {}
Changef.__index = Changef
setmetatable(Changef, { __index = Change })
Changef.metadata = {
	autocmd = "InsertLeave",
	desc = "Change text using f",
	instructions = "",
	tags = utility.flatten({ tag_index.cchange, tag_index.f }),
	input_template = "<target_register>cf<target_char>x<esc>",
}

function Changef:new()
	local base = Change:new()
	setmetatable(base, { __index = Changef })
	base.text_to_be_inserted = "x"
	base.line_text_after_change = ""
	return base
end

function Changef:activate()
	local line = utility.construct_char_line(self.target_char, self.cursor_center_pos + 10)
	self:change_f(line, movements.f)
end

function Changef:instructions()
	return "Change the text in between the cursor and '"
		.. self.target_char
		.. "' into '"
		.. self.text_to_be_inserted
		.. "' and exit insert mode."
end

return Changef
