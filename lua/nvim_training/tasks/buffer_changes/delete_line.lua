-- luacheck: globals vim

local Task = require("nvim_training.task")

local DeleteLineTask = Task:new()
DeleteLineTask.base_args = { autocmds = { "TextChanged" }, tags = { "buffer" } }
local utility = require("nvim_training.utility")

function DeleteLineTask:prepare()
	self:load_from_json("permutation.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)
	self.target_buffer = self.initial_buffer

	self.initial_lines_in_buffer = self:construct_line_table_from_buffer()
	local target_line = self.initial_lines_in_buffer[math.random(1, #self.initial_lines_in_buffer)]
	while target_line:len() == 0 do
		target_line = self.initial_lines_in_buffer[math.random(1, #self.initial_lines_in_buffer)]
	end

	self.desc = "Remove the line '" .. tostring(target_line) .. "' from the buffer."

	local line_count = vim.api.nvim_buf_line_count(0)
	local new_buffer_lines = vim.api.nvim_buf_get_lines(0, 0, line_count, false)

	local line_index = 0

	for i, line_el in pairs(new_buffer_lines) do
		if line_el == target_line then
			line_index = i - 1
		end
	end

	for i, v in pairs(self.initial_lines_in_buffer) do
		if target_line == v then
			table.remove(self.initial_lines_in_buffer, i)
		end
	end


	self.highlight = utility.create_highlights(line_index, 0, -1)


end

function DeleteLineTask:completed()
	local current_words_in_buffer = self:construct_line_table_from_buffer()
	local comparison = true
	for i, v in pairs(current_words_in_buffer) do
		local temp_true = (v == self.initial_lines_in_buffer[i])
		comparison = comparison and temp_true
	end

	return comparison
end

function DeleteLineTask:failed()
	return not self:completed()
end

function DeleteLineTask:construct_line_table_from_buffer()
	local line_count = vim.api.nvim_buf_line_count(0)
	return vim.api.nvim_buf_get_lines(0, 0, line_count, false)
end

function DeleteLineTask:teardown()
	utility.clean_highlight(self.highlight)
end

return DeleteLineTask
