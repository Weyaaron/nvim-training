local Task = require("nvim_training.task")

local DeleteWordTask = Task:new()
DeleteWordTask.base_args = { autocmds = { "TextChanged" }, tags = { "buffer" } }
local utility = require("nvim_training.utility")

function DeleteWordTask:prepare()
	self:load_from_json("permutation.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)
	self.target_buffer = self.initial_buffer

	local line_count = vim.api.nvim_buf_line_count(0)
	local new_cursor_pos = math.random(0, line_count)
	vim.api.nvim_win_set_cursor(0, { new_cursor_pos, 7 })

	self.initial_words_in_buffer = self:construct_word_table_from_buffer()
	local target_word = self.initial_words_in_buffer[math.random(1, #self.initial_words_in_buffer)]
	while target_word:len() == 0 do
		target_word = self.initial_words_in_buffer[math.random(1, #self.initial_words_in_buffer)]
	end

	self.desc = "Remove the word '" .. target_word .. "' from the buffer."

	local new_buffer_lines = vim.api.nvim_buf_get_lines(0, 0, line_count, false)
	local left_bound = 0
	local line_index = 0

	for i, line_el in pairs(new_buffer_lines) do
		local pieces = utility.split_str(line_el, " ")
		for pi, piece_el in pairs(pieces) do
			if piece_el == target_word then
				line_index = i - 1
				left_bound = string.find(line_el, target_word) - 1
			end
		end
	end

	local right_bound = left_bound + target_word:len()

	for i, v in pairs(self.initial_words_in_buffer) do
		if target_word == v then
			table.remove(self.initial_words_in_buffer, i)
		end
	end

	self.highlight_namespace = vim.api.nvim_create_namespace("BufferPermutationNameSpace")

	vim.api.nvim_set_hl(0, "UnderScore", { underline = true })

	vim.api.nvim_buf_add_highlight(0, self.highlight_namespace, "UnderScore", line_index, left_bound, right_bound)
end

function DeleteWordTask:completed()
	local current_words_in_buffer = self:construct_word_table_from_buffer()
	local comparison = true
	for i, v in pairs(current_words_in_buffer) do
		local temp_true = (v == self.initial_words_in_buffer[i])
		comparison = comparison and temp_true
	end

	return comparison
end

function DeleteWordTask:failed()
	return not self:completed()
end

function DeleteWordTask:construct_word_table_from_buffer()
	local result = {}
	local line_position = vim.api.nvim_win_get_cursor(0)[1] - 1
	local new_buffer_lines = vim.api.nvim_buf_get_lines(0, line_position, line_position + 1, false)

	for i, line_el in pairs(new_buffer_lines) do
		local pieces = utility.split_str(line_el, " ")
		for pi, piece_el in pairs(pieces) do
			if piece_el:len() > 0 then
				table.insert(result, piece_el)
			end
		end
	end

	return result
end

function DeleteWordTask:teardown()
	if self.highlight_namespace then
		vim.api.nvim_buf_clear_namespace(0, self.highlight_namespace, 0, -1)
	end
end

return DeleteWordTask
