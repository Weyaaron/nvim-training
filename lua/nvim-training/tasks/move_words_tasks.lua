local utility = require("nvim-training.utility")
local current_config = require("nvim-training.current_config")
local Task = require("nvim-training.task")

local MoveWordsTask = Task:new({ autocmd = "CursorMoved", jump_distance = 5 })
MoveWordsTask.__index = MoveWordsTask

function MoveWordsTask:intitialize_internals()
	self.jump_distance = math.random(4)

	self.autocmd = "CursorMoved"

	self.start_line_index = math.random(4)
	self.start_word_index = 2
	local lorem_ipsum = utility.lorem_ipsum_lines()
	self.custom_lorem_ipsum = string.gsub(lorem_ipsum, ",", "")

	--Todo: Does it matter that is not the way vim words behave? Atm not I guess.
	self.custom_lorem_ipsum = string.gsub(self.custom_lorem_ipsum, ".", "")

	-- self.start_position = utility.extract_x_y_for_random_word(self.custom_lorem_ipsum)
	-- print(self.start_position[1])
	-- self.end_position = utility.traverse_text_n_words_forward(
	-- self.custom_lorem_ipsum,
	-- self.start_position[1],
	-- self.start_position[2],
	-- 1
	-- )
end

function MoveWordsTask:setup()
	self:intitialize_internals()

	local function _inner_update()
		local lorem_ipsum = utility.lorem_ipsum_lines(4)
		-- local lorem_ipsum = self.custom_lorem_ipsum
		utility.update_buffer_respecting_header(lorem_ipsum)

		local exmark = utility.place_exmark_on_random_word()
		utility.traverse_text_n_words_forward_and_construct_exmark(exmark, 5)
		local x_y = vim.api.nvim_buf_get_extmark_by_id(0, current_config.exmark_name_space, exmark, {})
		vim.api.nvim_win_set_cursor(0, x_y)
		self.highlight = utility.create_highlight(x_y[1] - 1, x_y[2], 3)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveWordsTask:teardown(autocmd_callback_data)
	-- local cursor_position_y = vim.api.nvim_win_get_cursor(0)[2]

	-- return cursor_position_y + 1 == self.target_index_in_line
	return false
end

function MoveWordsTask:description()
	return "Move " .. self.jump_distance .. " Words."
end

return MoveWordsTask
