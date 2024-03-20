local utility = require("nvim-training.utility")
local current_config = require("nvim-training.current_config")
local Task = require("nvim-training.task")
local text_traversal = require("nvim-training.text_traversal")

local MoveWordsTask = Task:new({ autocmd = "CursorMoved", jump_distance = 5 })
MoveWordsTask.__index = MoveWordsTask

function MoveWordsTask:setup()
	self.jump_distance = math.random(2, 9)
	self.jump_distance = 2
	local function _inner_update()
		self.custom_lorem_ipsum = string.gsub(utility.lorem_ipsum_lines(), ",", "")
		self.custom_lorem_ipsum = string.gsub(self.custom_lorem_ipsum, "%.", "")
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
			starting_point[1] - current_config.header_length,
			starting_point[2]
		)
		vim.api.nvim_win_set_cursor(0, starting_point)
		char_list = text_traversal.traverse_n_words(char_list, self.jump_distance)

		self.end_pos = { 0, 0 }
		if #char_list > 0 then
			self.highlight =
				utility.create_highlight(current_config.header_length + char_list[1][2] - 1, char_list[1][3] - 1, 1)

			self.end_pos = { char_list[1][2] + current_config.header_length, char_list[1][3] - 1 }
		end
	end

	--Todo: Place end exmark
	vim.schedule_wrap(_inner_update)()
end

function MoveWordsTask:teardown(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local comp = (cursor_pos[1] == self.end_pos[1]) and (cursor_pos[2] == self.end_pos[2])
	-- print(cursor_pos[1], cursor_pos[2], self.end_pos[1], self.end_pos[2], comp)
	return comp
end

function MoveWordsTask:description()
	return "Move " .. self.jump_distance .. " Words."
end

return MoveWordsTask
