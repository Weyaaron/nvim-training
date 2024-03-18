local utility = require("nvim-training.utility")
local current_config = require("nvim-training.current_config")
local YankTask = require("nvim-training.tasks.yank_task")
local text_traversal = require("nvim-training.text_traversal")
local YankWordTask = YankTask:new({ target_text = "", autocmd = "TextYankPost" })
YankWordTask.__index = YankWordTask

function YankWordTask:setup()
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
		local starting_point = utility.calculate_random_point_in_text_bounds()

		local char_list =
			text_traversal.construct_index_table_from_text_lines(utility.split_str(utility.lorem_ipsum_lines(), "\n"))

		char_list = text_traversal.traverse_to_x_y(
			char_list,
			starting_point[1] - current_config.header_length,
			starting_point[2]
		)
		--Todo: Improv alg
		-- local first_word_bound = text_traversal.traverse_n_words(char_list, 1)
		-- starting_point = { first_word_bound[1][2], first_word_bound[1][3] }
		vim.api.nvim_win_set_cursor(0, starting_point)

		char_list = text_traversal.traverse_n_words(char_list, self.jump_distance - 1)
		-- print(starting_point[1], starting_point[2], #char_list)

		self.end_pos = { 0, 0 }
		if #char_list > 0 then
			self.highlight =
				utility.create_highlight(current_config.header_length + char_list[1][2] - 1, char_list[1][3] - 1, 1)

			self.end_pos = { char_list[1][2], char_list[1][3] }
		end
	end
	vim.schedule_wrap(_inner_update)()
end

function YankWordTask:description()
	return "Yank the text in between the cursor and the highlight"
end

return YankWordTask
