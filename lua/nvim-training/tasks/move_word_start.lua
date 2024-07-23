local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")

local MoveWordStart = {}
MoveWordStart.__index = MoveWordStart

setmetatable(MoveWordStart, { __index = Task })

MoveWordStart.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move to the start of the 'word'.",
	instructions = "Move to the start of the current word.",
	tags = "movement, word, horizontal",
}
function MoveWordStart:new()
	local base = Task:new()
	setmetatable(base, { __index = MoveWordStart })
	base.target_y_pos = 0
	return base
end
function MoveWordStart:activate()
	local function _inner_update()
		local cursor_in_line_middle = false
		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		while not cursor_in_line_middle do
			utility.set_buffer_to_rectangle_and_place_cursor_randomly()
			current_cursor_pos = vim.api.nvim_win_get_cursor(0)
			cursor_in_line_middle = current_cursor_pos[2] < 30
			cursor_in_line_middle = cursor_in_line_middle and current_cursor_pos[2] > 10

			local line = utility.get_line(current_cursor_pos[1])
			local char_at_cursor_pos = line:sub(current_cursor_pos[2] + 1, current_cursor_pos[2] + 1)
			if char_at_cursor_pos == " " then
				cursor_in_line_middle = false
			end
		end
		current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		local line = utility.get_line(current_cursor_pos[1])
		local word_positions = utility.calculate_word_bounds(line)
		local word_index_cursor = utility.calculate_word_index_from_cursor_pos(word_positions, current_cursor_pos[2])

		local offset = 0
		local cursor_is_at_word_start = current_cursor_pos[2] == word_positions[word_index_cursor][1]
		if cursor_is_at_word_start then
			offset = 1
		end
		self.target_y_pos = word_positions[word_index_cursor - offset][1]
		utility.create_highlight(current_cursor_pos[1] - 1, self.target_y_pos, 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveWordStart:deactivate(autocmd_args)
	return vim.api.nvim_win_get_cursor(0)[2] == self.target_y_pos
end

function MoveWordStart:instructions()
	return "Move to the beginning of the curent 'word'."
end

return MoveWordStart
