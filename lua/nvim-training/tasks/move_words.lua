local utility = require("nvim-training.utility")
local internal_config = require("nvim-training.internal_config")
local Task = require("nvim-training.task")
local text_traversal = require("nvim-training.text_traversal")

local MoveWordsTask = {}
MoveWordsTask.__index = MoveWordsTask

function MoveWordsTask:setup()
	local base = Task:new()
	setmetatable(base, { __index = MoveWordsTask })
	self.autocmd = "CursorMoved"

	self.jump_distance = math.random(2, 9)
	local function _inner_update()
		self.custom_lorem_ipsum = utility.lorem_ipsum_lines():gsub(",", ""):gsub("%.", "")
		utility.update_buffer_respecting_header(self.custom_lorem_ipsum)

		local starting_point = utility.calculate_random_point_in_text_bounds()

		local max_lines = vim.api.nvim_buf_line_count(0)
		--Todo: Replace this with an actuall model of words in the text
		while starting_point[1] >= max_lines - 2 do
			starting_point = utility.calculate_random_point_in_text_bounds()
		end
		starting_point = { 10, 6 }
		local char_list =
			text_traversal.construct_index_table_from_text_lines(utility.split_str(self.custom_lorem_ipsum))

		char_list = text_traversal.traverse_to_x_y(
			char_list,
			starting_point[1] - internal_config.header_length,
			starting_point[2]
		)
		vim.api.nvim_win_set_cursor(0, starting_point)
		char_list = text_traversal.traverse_n_words(char_list, self.jump_distance)

		self.end_pos = { 0, 0 }
		if #char_list > 0 then
			utility.create_highlight(internal_config.header_length + char_list[1][2] - 1, char_list[1][3] - 1, 1)

			self.end_pos = { char_list[1][2] + internal_config.header_length, char_list[1][3] - 1 }
		end
	end

	vim.schedule_wrap(_inner_update)()
	return base
end

function MoveWordsTask:teardown(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	return (cursor_pos[1] == self.end_pos[1]) and (cursor_pos[2] == self.end_pos[2])
end

function MoveWordsTask:description()
	return "Move " .. self.jump_distance .. " Words."
end

return MoveWordsTask
