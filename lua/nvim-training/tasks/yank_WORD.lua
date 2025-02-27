local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")
local Yank = require("nvim-training.tasks.yank")
local tag_index = require("nvim-training.tag_index")

local YankWORD = {}
YankWORD.__index = YankWORD
setmetatable(YankWORD, { __index = Yank })
YankWORD.metadata = {
	autocmd = "TextYankPost",
	desc = "Yank multiple WORDS.",
	instructions = "",
	tags = utility.flatten({ tag_index.yank, tag_index.WORD }),
	input_template = "<target_register>y<counter>W",
}

function YankWORD:new()
	local base = Yank:new()
	setmetatable(base, { __index = YankWORD })
	return base
end

function YankWORD:activate()
	local function _inner_update()
		local line = utility.construct_WORDS_line()
		self.cursor_target = utility.do_word_preparation(line, movements.WORDS, self.counter, math.random(1, 10))

		local target_with_offset = { self.cursor_target[1], self.cursor_target[2] - 2 }
		self.target_text = utility.extract_text_from_coordinates(self.cursor_target)
		self.target_text = utility.extract_text_from_coordinates(target_with_offset)
	end
	vim.schedule_wrap(_inner_update)()
end

function YankWORD:instructions()
	return "Yank " .. self.counter .. " WORDS(s)" .. utility.construct_register_description(self.target_register) .. "."
end

return YankWORD
