local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")

local MoveWordEnd = {}
MoveWordEnd.__index = MoveWordEnd
setmetatable(MoveWordEnd, { __index = Task })
MoveWordEnd.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move to the end of the current 'word'.",
	instructions = "Move to the end of the current 'word'.",
	tags = "movement, word, end, vertical",
}

function MoveWordEnd:new()
	local base = Task:new()
	setmetatable(base, { __index = MoveWordEnd })
	base.target_y_pos = 0
	return base
end
function MoveWordEnd:activate()
	local function _inner_update()
		local cursor_at_line_start = false

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		while not cursor_at_line_start do
			utility.set_buffer_to_rectangle_and_place_cursor_randomly()
			current_cursor_pos = vim.api.nvim_win_get_cursor(0)
			cursor_at_line_start = current_cursor_pos[2] < 15
		end

		current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		current_cursor_pos = { current_cursor_pos[1], current_cursor_pos[2] + 1 }
		local line = utility.get_line(current_cursor_pos[1])
		local word_positions = utility.calculate_word_bounds(line)
		local word_index = utility.calculate_word_index_from_cursor_pos(word_positions, current_cursor_pos[2])
		utility.create_highlight(current_cursor_pos[1] - 1, word_positions[word_index][2] - 1, 1)

		local offset = 0
		local cursor_is_at_wordend = current_cursor_pos[2] == word_positions[word_index][2]

		if cursor_is_at_wordend then
			offset = 1
		end
		self.target_y_pos = word_positions[word_index + offset][2] - 1
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveWordEnd:deactivate(autocmd_args)
	local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
	return current_cursor_pos[2] == self.target_y_pos
end

return MoveWordEnd
