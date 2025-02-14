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
	return base
end

function ChangeWord:activate()
	local function _inner_update()
		local line = utility.construct_words_line()

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], 10 })
		current_cursor_pos = vim.api.nvim_win_get_cursor(0)

		local cursor_pos_after_movement = movements.words(line, current_cursor_pos[2], self.counter)

		local line = utility.get_line(current_cursor_pos[1])
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
