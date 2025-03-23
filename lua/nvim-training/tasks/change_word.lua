local Change = require("nvim-training.tasks.change")
local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local ChangeWord = {}
ChangeWord.__index = ChangeWord
setmetatable(ChangeWord, { __index = Change })
ChangeWord.metadata = {
	autocmd = "InsertLeave",
	desc = "Change multiple words.",
	instructions = "",
	tags = utility.flatten({ tag_index.cchange, tag_index.word }),

	input_template = "c<counter>wx<esc>",
}

function ChangeWord:new()
	local base = Change:new()
	setmetatable(base, { __index = ChangeWord })
	base.line_text_after_change = ""
	return base
end

function ChangeWord:activate()
	local function _inner_update()
		local cursor_start = 10
		local move_res = -1
		local line = ""
		while move_res == -1 do
			line = utility.construct_words_line()
			move_res = movements.words(line, cursor_start, self.counter)
		end

		utility.set_buffer_to_rectangle_with_line(line)

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], 10 })
		current_cursor_pos = vim.api.nvim_win_get_cursor(0)

		self.line_text_after_change = line:sub(0, current_cursor_pos[2])
			.. self.text_to_be_inserted
			.. line:sub(move_res, #line)

		self.cursor_target = current_cursor_pos

		utility.construct_word_hls_forwards(self.counter)
		utility.construct_highlight(current_cursor_pos[1], move_res, 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function ChangeWord:instructions()
	return "Change the text of " .. self.counter .. " word(s) into '" .. self.text_to_be_inserted .. "'."
end

return ChangeWord
