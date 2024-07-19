local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")

local DeleteWordTask = Task:new()
DeleteWordTask.__index = DeleteWordTask

function DeleteWordTask:new()
	local base = Task:new()
	setmetatable(base, { __index = DeleteWordTask })
	base.autocmd = "TextChanged"

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

		--Todo: Not as easy since you need cursor diffs

		current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		local line = utility.get_line(current_cursor_pos[1])
		base.word_position_length = #utility.calculate_word_bounds(line)
	end
	vim.schedule_wrap(_inner_update)()
	return base
end
function DeleteWordTask:deactivate(autocmd_callback_data)
	local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_line(current_cursor_pos[1])
	local word_positions = utility.calculate_word_bounds(line)
	return self.word_position_length - 1 == #word_positions
end
function DeleteWordTask:description()
	return "Delete using the 'word'-motion."
end

return DeleteWordTask
