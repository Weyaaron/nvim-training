local Task = require("nvim_training.task")
local utility = require("nvim_training.utility")

local MoveWordForwardTask = Task:new()
MoveWordForwardTask.base_args = { cursor_target = 0, tags = { "movement" } }

function MoveWordForwardTask:prepare()
	self:load_from_json("test.buffer", { "broken_key" })

	self.previous_cursor_position = 0

	utility.replace_main_buffer_with_str(self.initial_buffer)
	--vim.api.nvim_win_set_cursor(0, buffer_data["cursor_position"])

	local cursor_position_tuple = vim.api.nvim_win_get_cursor(0)
	local current_line_index = cursor_position_tuple[1] - 1
	local current_y_cursor_index = cursor_position_tuple[2]

	local current_line = vim.api.nvim_buf_get_lines(0, current_line_index, current_line_index + 1, false)[1]
	current_line = string.sub(current_line, current_y_cursor_index)

	local jump_target_offset_in_words = math.random(2, 5)

	local cursor_offset_in_chars = 0
	local words_in_line = utility.split_str(current_line, " ")

	local word_lengths = {}

	--This function breaks on multiple whitespaces between words
	for i = 1, jump_target_offset_in_words + 1 do
		if string.len(words_in_line[i]) > 0 then
			local current_word_length = string.len(words_in_line[i]) + 1
			word_lengths[i] = current_word_length
			cursor_offset_in_chars = cursor_offset_in_chars + current_word_length
		end
	end

	self.desc = "Jump " .. tostring(jump_target_offset_in_words) .. " words relative to your cursor."

	self.highlight_namespace = vim.api.nvim_create_namespace("JumpWordLineNameSpace")

	--Todo: Fix highlight!

	vim.api.nvim_set_hl(0, "UnderScore", { underline = true })

	local left_hl_bound = current_y_cursor_index + cursor_offset_in_chars
	self.cursor_target = left_hl_bound

	vim.api.nvim_buf_add_highlight(
		0,
		self.highlight_namespace,
		"UnderScore",
		current_line_index,
		left_hl_bound,
		left_hl_bound + 1
	)
end

function MoveWordForwardTask:failed()
	if self.cursor_target then
		return self.cursor_target - vim.api.nvim_win_get_cursor(0)[2] == 0
	end
	return false
end

function MoveWordForwardTask:completed()
	return not MoveWordForwardTask:failed()
end

function MoveWordForwardTask:teardown()
	if self.highlight_namespace then
		vim.api.nvim_buf_clear_namespace(0, self.highlight_namespace, 0, -1)
	end
end

return MoveWordForwardTask
