local utility = require("nvim-training.utility")
local internal_config = require("nvim-training.internal_config")
local YankTask = require("nvim-training.tasks.yank_task")
local text_traversal = require("nvim-training.text_traversal")
local YankWordTask = {}
YankWordTask.__index = YankWordTask

function YankWordTask:setup()
	local base = YankTask:new()
	setmetatable(base, { __index = YankWordTask })
	self.autocmd = "TextYankPost"
	self.target_text = ""
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
		starting_point = { 10, 65 }
		vim.api.nvim_win_set_cursor(0, starting_point)
		local char_list =
			text_traversal.construct_index_table_from_text_lines(utility.split_str(self.custom_lorem_ipsum))

		char_list = text_traversal.traverse_to_x_y(
			char_list,
			starting_point[1] - internal_config.header_length,
			starting_point[2]
		)
		local copy_of_char_list = char_list
		vim.api.nvim_win_set_cursor(0, { starting_point[1], starting_point[2] - 1 })

		char_list = text_traversal.traverse_n_words(char_list, self.jump_distance)

		self.end_pos = { 0, 0 }
		if #char_list > 0 then
			utility.create_highlight(internal_config.header_length + char_list[1][2] - 1, char_list[1][3] - 1, 1)

			self.end_pos = { char_list[1][2] + internal_config.header_length, char_list[1][3] - 1 }
		end
		local length_diff = #copy_of_char_list - #char_list
		local char_list_between_traversals = { unpack(copy_of_char_list, 1, length_diff) }
		local final_text = ""

		-- print(length_diff, char_list_between_traversals[1][1])
		for i = 1, #char_list_between_traversals do
			final_text = final_text .. char_list_between_traversals[i][1]
		end
		-- print(final_text)

		self.target_text = final_text
	end
	vim.schedule_wrap(_inner_update)()
	return base
end

function YankWordTask:description()
	return "Yank the text in between the cursor and the highlight"
end

return YankWordTask
