local utility = require("nvim-training.utility")
local Change = require("nvim-training.tasks.change")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local ChangeWord = {}
ChangeWord.__index = ChangeWord
setmetatable(ChangeWord, { __index = Change })
ChangeWord.metadata = {
	autocmd = "InsertLeave",
	desc = "Change multiple words.",
	instructions = "",
	tags = utility.flatten({ Change.metadata.tags, tag_index.word }),
	input_template = "c<counter>wx<esc>",
}

function ChangeWord:new()
	local base = Change:new()
	setmetatable(base, { __index = ChangeWord })
	base.line_text_after_change = ""
	base.text_to_be_inserted = "x"
	return base
end

function ChangeWord:deactivate()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	if type(self.cursor_target) == "number" then
		print("Target has to be type table, current value is " .. tostring(self.cursor_target))
	end
	local current_line = utility.get_line(cursor_pos[1])
	print(current_line, self.line_text_after_change, #current_line, #self.line_text_after_change)
	return current_line == self.line_text_after_change
end

function ChangeWord:activate()
	local function _inner_update()
		local line = utility.construct_words_line()
		self.counter = 1
		line = "1111 2222 3333 4444 5555 6666 7777 8888 9999"
		self.cursor_target = utility.do_word_preparation(line, movements.words, self.counter, 1)
		-- local target_with_offset = { self.cursor_target[1], self.cursor_target[2] + 2 }
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		local text_between_positions = line:sub(cursor_pos[2], self.cursor_target[2] - 1)
		self.line_text_after_change = string.gsub(line, text_between_positions, self.text_to_be_inserted)
		print(vim.inspect(self.cursor_target), text_between_positions, self.line_text_after_change)
	end
	vim.schedule_wrap(_inner_update)()
end

function ChangeWord:instructions()
	return "Change the text of " .. self.counter .. " word(s) into '" .. self.text_to_be_inserted .. "'."
end

return ChangeWord
