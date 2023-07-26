local utility = require("stelfnvim_training.utility")
local Task = require("stelfnvim_training.task")

local BufferPermutationTask = Task:new()
BufferPermutationTask.base_args = { autocmds = { "TextChanged" }, tags = { "buffer" } }

function BufferPermutationTask:prepare()
	self:load_from_json("permutation.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)
end

function BufferPermutationTask:failed()
	return false
end

function BufferPermutationTask:completed()
	local lines = vim.api.nvim_buf_line_count(0)
	local new_buffer_lines = vim.api.nvim_buf_get_lines(0, 0, lines, false)

	local target_str = utility.split_str(self.new_buffer)

	local comparison = #target_str == #new_buffer_lines
	if comparison then
		for i, v in pairs(new_buffer_lines) do
			comparison = comparison and v == target_str[i]
		end
	end

	return comparison
end

function BufferPermutationTask:teardown() end

return BufferPermutationTask
