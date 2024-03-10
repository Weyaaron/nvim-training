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
	local lorem_ipsum = utility.lorem_ipsum_lines(4)
	self.custom_lorem_ipsum = string.gsub(lorem_ipsum, ",", "")

	--Todo: Does it matter that is not the way vim words behave? Atm not I guess.
	self.custom_lorem_ipsum = string.gsub(self.custom_lorem_ipsum, ".", "")

	self.intitial_word = utility.construct_random_word_from_text(self.custom_lorem_ipsum)
	self.target_word = utility.traverse_text_wordwise_forward(self.custom_lorem_ipsum, start_word)
	local lines = utility.split_str(lorem_ipsum, "\n")
	local target_line = lines[self.start_line_index]
	local words_in_line = utility.split_str(target_line, " ")
	self.initial_word = words_in_line[self.start_word_index]
	self.target_word = words_in_line[self.start_word_index + self.jump_distance]
	self.start_index_in_line = string.find(target_line, self.initial_word)
	self.target_index_in_line = string.find(target_line, self.target_word)
end

function MoveWordsTask:setup()
	self:intitialize_internals()
	utility.update_buffer_respecting_header(self.custom_lorem_ipsum)
	local function _inner_update()
		vim.api.nvim_win_set_cursor(
			0,
			{ current_config.header_length + self.start_line_index, self.start_index_in_line - 1 }
		)
		self.highlight = utility.create_highlight(
			current_config.header_length + self.start_line_index - 1,
			self.target_index_in_line - 1,
			1
		)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveWordsTask:teardown(autocmd_callback_data)
	local cursor_position_y = vim.api.nvim_win_get_cursor(0)[2]

	return cursor_position_y + 1 == self.target_index_in_line
end

function MoveWordsTask:description()
	return "Move " .. self.jump_distance .. " Words."
end

return MoveWordsTask
