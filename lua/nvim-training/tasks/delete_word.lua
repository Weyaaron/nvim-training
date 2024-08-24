local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local movements = require("nvim-training.movements")

local DeleteWord = {}

DeleteWord.__index = DeleteWord
setmetatable(DeleteWord, { __index = Delete })
DeleteWord.__metadata = {
	autocmd = "TextChanged",
	desc = "Delete using 'w'.",
	instructions = "",
	tags = "deletion, movement, word",
}

function DeleteWord:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteWord })

	return base
end

function DeleteWord:activate()
	local function _inner_update()
		local word_line = utility.construct_words_line()
		utility.set_buffer_to_rectangle_with_line(word_line)

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], 20 })

		self.cursor_target = movements.words(self.counter)
		current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		utility.create_highlight(current_cursor_pos[1] - 1, self.cursor_target[2], 1)

		self.target_text = word_line:sub(current_cursor_pos[2] + 1, self.cursor_target[2])
	end
	vim.schedule_wrap(_inner_update)()
end

function DeleteWord:instructions()
	return "Delete " .. self.counter .. " word(s) using 'w'."
end
return DeleteWord
