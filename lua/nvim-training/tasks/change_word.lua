local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local ChangeWord = {}
ChangeWord.__index = ChangeWord
setmetatable(ChangeWord, { __index = Task })
ChangeWord.metadata = {
	autocmd = "InsertLeave",
	desc = "Change multiple words.",
	instructions = "",
	tags = utility.flatten({ tag_index.change, tag_index.word }),

	input_template = "c<counter>wx<esc>",
}

function ChangeWord:new()
	local base = Task:new()
	setmetatable(base, { __index = ChangeWord })
	base.line_text_after_change = ""
	base.text_to_be_inserted = "x"
	base.constructed_line = ""
	return base
end

function ChangeWord:deactivate()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	if type(self.cursor_target) == "number" then
		print("Target has to be type table, current value is " .. tostring(self.cursor_target))
	end
	local current_line = utility.get_line(cursor_pos[1])
	if not _G.status then
		_G.status = {}
	end
	_G.status.comparison = current_line == self.line_text_after_change
	_G.status.current_line = current_line
	_G.status.line_text_after_change = self.line_text_after_change
	_G.status.constructed_line = self.constructed_line
	return current_line == self.line_text_after_change
end
function ChangeWord:activate()
	local function _inner_update()
		local line = utility.construct_words_line()
		line = "word1 word2 word3 word4"
		self.constructed_line = line

		-- local tmp_line = "word1 word2 word3 word4"
		-- line = tmp_line
		utility.set_buffer_to_rectangle_with_line(line)

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], 2 })
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], 5 }) --Should be on a space
		current_cursor_pos = vim.api.nvim_win_get_cursor(0)

		if not _G.status then
			_G.status = {}
		end
		local char_at_cp = line:sub(current_cursor_pos[2], current_cursor_pos[2])
		_G.status.char_at_cp = char_at_cp
		-- if char_at_cp == " " then
		-- 	vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], 11 })
		-- end

		_G.status.initial_line = line
		current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		local cursor_pos_after_movement = movements.words(line, current_cursor_pos[2], self.counter)

		self.line_text_after_change = line:sub(0, current_cursor_pos[2])
			.. self.text_to_be_inserted
			.. line:sub(cursor_pos_after_movement, #line)

		self.cursor_target = current_cursor_pos

		utility.construct_word_hls_forwards(self.counter)
		utility.construct_highlight(current_cursor_pos[1], cursor_pos_after_movement, 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function ChangeWord:instructions()
	return "Change the text of " .. self.counter .. " word(s) into '" .. self.text_to_be_inserted .. "'."
end

return ChangeWord
