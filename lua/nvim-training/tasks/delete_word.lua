local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local DeleteWord = {}
DeleteWord.__index = DeleteWord
setmetatable(DeleteWord, { __index = Delete })
DeleteWord.__metadata = {
	autocmd = "TextChanged",
	desc = "Delete multiple words.",
	instructions = "",
	tags = Delete.__metadata.tags .. tag_index.words,
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

		current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], 20 })
		self.cursor_target = { current_cursor_pos[1], movements.words(word_line, current_cursor_pos[2], self.counter) }
		current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		utility.construct_highlight(current_cursor_pos[1], self.cursor_target[2], 1)

		self.target_text = word_line:sub(current_cursor_pos[2] + 1, self.cursor_target[2])

		utility.construct_word_hls_forwards(self.counter)
		utility.construct_highlight(current_cursor_pos[1], self.cursor_target[2], 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function DeleteWord:instructions()
	return "Delete " .. self.counter .. " word(s)."
end
return DeleteWord
