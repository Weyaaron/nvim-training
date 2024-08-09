
local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local user_config = require("nvim-training.user_config")
local YankWord = {}

YankWord.__index = YankWord
setmetatable(YankWord, { __index = Move })
YankWord.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move using w.",
	instructions = "Move using w.",
	tags = "movement, word, horizontal, w",
}

function YankWord:new()
	local base = Move:new()
	setmetatable(base, { __index = YankWord })
	base.target_y_pos = 0

	base.counter = 1
	if user_config.enable_counters then
		base.counter = math.random(2, 7)
	end

	base.cursor_target = { 0, 0 }
	return base
end

function YankWord:activate()
	local function _inner_update()
		local cursor_at_line_start = false
		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		while not cursor_at_line_start do
			utility.set_buffer_to_rectangle_and_place_cursor_randomly()
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

		local offset = self.counter
		local cursor_is_at_wordend = current_cursor_pos[2] == word_positions[word_index_cursor][2]

		if cursor_is_at_wordend then
			offset = 1
		end
		self.cursor_target = { current_cursor_pos[1], word_positions[word_index_cursor + offset][1] }
		utility.create_highlight(current_cursor_pos[1] - 1, self.target_y_pos, 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function YankWord:instructions()
	return "Move " .. self.counter .. " word(s) using 'w'."
end

return YankWord
