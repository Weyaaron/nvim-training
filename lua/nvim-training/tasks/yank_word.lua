local utility = require("nvim-training.utility")
local internal_config = require("nvim-training.internal_config")
local YankTask = require("nvim-training.tasks.yank")
local text_traversal = require("nvim-training.text_traversal")
local YankWord = YankTask:new()
YankWord.__index = YankWord

function YankWord:new()
	local base = YankTask:new()
	setmetatable(base, { __index = YankWord })
	self.autocmd = "TextYankPost"
	self.target_text = ""
	self.jump_distance = 2

	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()

		self.target_text = utility.highlight_random_word()
	end
	vim.schedule_wrap(_inner_update)()
	return base
end

function YankWord:description()
	return "Yank the text in between the cursor and the highlight"
end

return YankWord
