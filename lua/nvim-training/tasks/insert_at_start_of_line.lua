local utility = require("nvim-training.utility")
local Change = require("nvim-training.tasks.change")

local InsertAtLineBeginning = {}
InsertAtLineBeginning.__index = InsertAtLineBeginning
setmetatable(InsertAtLineBeginning, { __index = Change })
InsertAtLineBeginning.__metadata = {
	autocmd = "InsertLeave",
	desc = "Insert text at the start of the line.",
	instructions = "Insert 'x' at the start of the line and leave Insert-Mode.",
	tags = "insert, I, start",
}

function InsertAtLineBeginning:new()
	local base = Change:new()
	setmetatable(base, { __index = InsertAtLineBeginning })
	base.target_text = ""

	return base
end

function InsertAtLineBeginning:activate()
	local function _inner_update()
		local word_line = utility.construct_words_line()
		utility.set_buffer_to_rectangle_with_line(word_line)

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], 20 })

		self.target_text = "x" .. word_line:sub(2, 2)
	end
	vim.schedule_wrap(_inner_update)()
end

return InsertAtLineBeginning
