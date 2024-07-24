local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")

local DeleteWordTask = {}

DeleteWordTask.__index = DeleteWordTask
setmetatable(DeleteWordTask, { __index = Task })
DeleteWordTask.__metadata = {
	autocmd = "TextChanged",
	desc = "Delete the char at the cursor.",
	instructions = "Delete the char at the cursor.",
	tags = "deletion, movement,word",
}

function DeleteWordTask:new()
	local base = Task:new()
	setmetatable(base, { __index = DeleteWordTask })
	base.sub_word = ""
	return base
end

function DeleteWordTask:activate()
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

		-- utility.set_buffer_to_rectangle_with_line(" TestWord,")
		-- current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		--
		-- vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], 3 })

		current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		local line = utility.get_line(current_cursor_pos[1])
		local word_bounds = utility.calculate_word_bounds(line)
		local word_index = utility.calculate_word_index_from_cursor_pos(word_bounds, current_cursor_pos[2])
		self.sub_word = line:sub(current_cursor_pos[2] + 1, word_bounds[word_index][2] - 1)
	end
	vim.schedule_wrap(_inner_update)()
end
function DeleteWordTask:deactivate(autocmd_callback_data)
	local reg_content = vim.fn.getreg('""')
	print(reg_content, "_", self.sub_word, "_")
	return reg_content == self.sub_word
	-- local cursor_pos = vim.api.nvim_win_get_cursor(0)
	-- local current_line = utility.get_line(cursor_pos[1])
	-- local text_inside_brackets = utility.extract_text_in_brackets(current_line, user_config.bracket_pairs[1])
	-- local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
	-- local line = utility.get_line(current_cursor_pos[1])
	-- local word_positions = utility.calculate_word_bounds(line)
	-- -- return self.word_position_length - 1 == #word_positions
	-- return false
end
function DeleteWordTask:instructions()
	return "Delete using the 'word'-motion."
end

return DeleteWordTask
