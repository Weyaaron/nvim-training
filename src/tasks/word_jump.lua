local JumpWordTask = {}

local Task = require("src.task")
local utility = require("src.utility")

function JumpWordTask:new()
	local base = Task:new()
	setmetatable(base, { __index = self })
	base:load_from_json("./buffer_data/test.buffer")
	return base
end

function JumpWordTask:prepare()
	self.desc = "Jump words"

	self.previous_cursor_position = 0
	self.cursor_target = 0

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

	jump_word_task.desc = "Jump " .. tostring(jump_target_offset_in_words) .. " words relative to your cursor."
	jump_word_task.desc = tostring(jump_target_offset_in_words) .. ":" .. tostring(cursor_offset_in_chars)

	self.highlight_namespace = vim.api.nvim_create_namespace("JumpWordLineNameSpace")

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

function JumpWordTask:failed()
	return self.cursor_target - vim.api.nvim_win_get_cursor(0)[2] == 0
end

function JumpWordTask:completed()
	return not JumpWordTask:failed()
end

function JumpWordTask:teardown()
	if self.highlight_namespace then
		vim.api.nvim_buf_clear_namespace(0, self.highlight_namespace, 0, -1)
	end
end

return JumpWordTask
