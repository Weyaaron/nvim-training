local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")
local MoveWord = {}
MoveWord.__index = MoveWord
setmetatable(MoveWord, { __index = Task })
MoveWord.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move using w.",
	instructions = "Move using w.",
	tags = "movement, word, horizontal, w",
}

function MoveWord:new()
	local base = Task:new()
	setmetatable(base, { __index = MoveWord })
	base.target_y_pos = 0
	return base
end

function MoveWord:activate()
	local function _inner_update()
		local cursor_at_line_start = false
		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		while not cursor_at_line_start do
			utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
			current_cursor_pos = vim.api.nvim_win_get_cursor(0)
			cursor_at_line_start = current_cursor_pos[2] < 15

			local line = utility.get_line(current_cursor_pos[1])
			local char_at_cursor_pos = line:sub(current_cursor_pos[2] + 1, current_cursor_pos[2] + 1)
			if char_at_cursor_pos == " " then
				cursor_at_line_start = false
			end
		end

		current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		local line = utility.get_line(current_cursor_pos[1])
		local word_positions = utility.calculate_word_bounds(line)
		local word_index_cursor = utility.calculate_word_index_from_cursor_pos(word_positions, current_cursor_pos[2])

		local offset = 0
		local cursor_is_at_wordend = current_cursor_pos[2] == word_positions[word_index_cursor][2]

		if cursor_is_at_wordend then
			offset = 1
		end
		self.target_y_pos = word_positions[word_index_cursor + 1 + offset][1]
		utility.create_highlight(current_cursor_pos[1] - 1, self.target_y_pos, 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveWord:deactivate(autocmd_args)
	return vim.api.nvim_win_get_cursor(0)[2] == self.target_y_pos
end

return MoveWord
