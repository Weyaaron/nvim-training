local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local DeleteWORD = {}
DeleteWORD.__index = DeleteWORD
setmetatable(DeleteWORD, { __index = Delete })
DeleteWORD.metadata = {
	autocmd = "TextChanged",
	desc = "Delete multiple WORDs.",
	instructions = "",
	tags = utility.flatten({ tag_index.deletion, tag_index.WORD }),
	input_template = "<target_register>d<counter>W",
}

function DeleteWORD:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteWORD })
	return base
end

function DeleteWORD:activate()
	local function _inner_update()
		local line = utility.construct_WORDS_line()
		self.cursor_target = utility.do_word_preparation(line, movements.WORDS, self.counter, math.random(1, 10))
		self.target_text = utility.extract_text_from_word_coordinates(self.cursor_target)
	end
	vim.schedule_wrap(_inner_update)()
end

function DeleteWORD:instructions()
	return "Delete "
		.. self.counter
		.. " WORDS(s)"
		.. utility.construct_register_description(self.target_register)
		.. "."
end
return DeleteWORD
