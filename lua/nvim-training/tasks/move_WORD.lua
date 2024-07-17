local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")
local template_index = require("nvim-training.template_index")
local MoveWORD = Task:new()
MoveWORD.__index = MoveWORD

function MoveWORD:new()
	local base = Task:new()
	setmetatable(base, { __index = MoveWORD })
	base.autocmd = "CursorMoved"
	base.target_y_pos = 0

	local function _inner_update()
		local cursor_at_line_start = false
		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		while not cursor_at_line_start do
			utility.update_buffer_respecting_header(utility.load_template(template_index.LoremIpsumWORDS))
			utility.move_cursor_to_random_point()
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
		local word_positions = utility.calculate_WORD_bounds(line)
		local word_index_cursor = utility.calculate_word_index_from_cursor_pos(word_positions, current_cursor_pos[2])

		local offset = 0
		local cursor_is_at_wordend = current_cursor_pos[2] == word_positions[word_index_cursor][2]

		if cursor_is_at_wordend then
			offset = 1
		end
		base.target_y_pos = word_positions[word_index_cursor + 1 + offset][1]
		utility.create_highlight(current_cursor_pos[1] - 1, base.target_y_pos, 1)
	end
	vim.schedule_wrap(_inner_update)()
	return base
end

function MoveWORD:teardown(autocmd_args)
	return vim.api.nvim_win_get_cursor(0)[2] == self.target_y_pos
end

function MoveWORD:description()
	return "Move a 'WORD'."
end

return MoveWORD
