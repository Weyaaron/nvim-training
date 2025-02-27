local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")
local Yank = require("nvim-training.tasks.yank")
local tag_index = require("nvim-training.tag_index")

local YankWord = {}
YankWord.__index = YankWord
setmetatable(YankWord, { __index = Yank })
YankWord.metadata = {
	autocmd = "TextYankPost",
	desc = "Yank multiple words.",
	instructions = "",
	tags = utility.flatten({ tag_index.yank, tag_index.word }),
	input_template = "<target_register>y<counter>w",
}

function YankWord:new()
	local base = Yank:new()
	setmetatable(base, { __index = YankWord })
	base.counter = 1
	return base
end

function YankWord:activate()
	local function _inner_update()
		local line = utility.construct_words_line()
		self.cursor_target = utility.do_word_preparation(line, movements.words, self.counter, math.random(1, 10))
		self.target_text = utility.extract_text_from_coordinates(self.cursor_target)

		local target_with_offset = { self.cursor_target[1], self.cursor_target[2] - 1 }
		-- self.target_text = utility.extract_text_from_coordinates(self.cursor_target)
		self.target_text = utility.extract_text_from_coordinates(target_with_offset)
	end

	vim.schedule_wrap(_inner_update)()
end

function YankWord:instructions()
	return "Yank " .. self.counter .. " word(s)" .. utility.construct_register_description(self.target_register) .. "."
end

return YankWord
