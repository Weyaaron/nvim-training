local utility = require("nvim-training.utility")
local text_traversal = require("nvim-training.text_traversal")
local current_config = require("nvim-training.current_config")
local Task = require("nvim-training.task")

local TestTask = Task:new({ autocmd = "CursorMoved" })
TestTask.__index = TestTask

function TestTask:setup()
	local function _inner_update()
		local lorem_ipsum_full_text = utility.lorem_ipsum_lines()
		local lorem_ipsum_in_line_format = utility.split_str(lorem_ipsum_full_text, "\n")
		utility.update_buffer_respecting_header(lorem_ipsum_full_text)
		local random_point = utility.calculate_random_point_in_text_bounds()
		-- local random_point = { 9, 15 }
		vim.api.nvim_win_set_cursor(0, random_point)

		-- vim.api.nvim_win_set_cursor(0, { current_config.header_length + 1, 0 })
		-- vim.api.nvim_buf_set_mark(0, self.mark_name, self.target_line, 0, {})
		-- utility.update_buffer_respecting_header(self.buffer_text)
		-- vim.api.nvim_win_set_cursor(0, { current_config.header_length + 2, 1 })
		local char_list = text_traversal.construct_index_table_from_text_lines(lorem_ipsum_in_line_format)

		char_list =
			text_traversal.traverse_to_x_y(char_list, random_point[1] - current_config.header_length, random_point[2])

		print(random_point[1], random_point[2], #char_list)
		-- goto continue
		for i = 1, 10 do
			char_list = text_traversal.traverse_n_words(char_list, 1)
			if #char_list > 0 then
				self.highlight =
					utility.create_highlight(current_config.header_length + char_list[1][2] - 1, char_list[1][3] - 1, 1)
			end
		end
		::continue::
	end
	vim.schedule_wrap(_inner_update)()
end

function TestTask:teardown(autocmd_callback_data)
	return false
end

function TestTask:description()
	return "For Test Purposes only!"
end

return TestTask
