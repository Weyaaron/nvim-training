local Change = require("nvim-training.tasks.change")
local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local ChangeF = {}
ChangeF.__index = ChangeF
setmetatable(ChangeF, { __index = Change })
ChangeF.metadata = {
	autocmd = "InsertLeave",
	desc = "Change text using F",
	instructions = "",
	tags = utility.flatten({ tag_index.change, tag_index.F }),
	input_template = "cF<target_char>x<esc>",
}

function ChangeF:new()
	local base = Change:new()
	setmetatable(base, { __index = ChangeF })
	base.line_text_after_change = ""
	return base
end

function ChangeF:activate()
	local line = utility.construct_char_line(self.target_char, self.cursor_center_pos - 10)
	self:change_f(line, movements.F)
end

function ChangeF:instructions()
	return "Change the text in between the cursor and '"
		.. self.target_char
		.. "' into '"
		.. self.text_to_be_inserted
		.. "' and exit insert mode."
end

return ChangeF
