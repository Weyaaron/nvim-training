local utility = require("nvim-training.utility")
local YankTask = require("nvim-training.tasks.yank")
local YankWord = YankTask:new()
YankWord.__index = YankWord

function YankWord:new()
	local base = YankTask:new()
	setmetatable(base, { __index = YankWord })
	self.autocmd = "TextYankPost"
	self.target_text = ""

	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()

		local random_line_index = utility.random_line_index()
		local selected = utility.select_random_word_bounds_at_line(random_line_index)

		utility.create_highlight(random_line_index, selected[1] - 1, selected[2])
		local ith_line = utility.get_line(random_line_index)
		base.target_text = string.sub(ith_line, selected[1], selected[1] + selected[2])
	end
	vim.schedule_wrap(_inner_update)()
	return base
end

function YankWord:description()
	return "Yank the highlighted word"
end

return YankWord
