local buffer_permutation_task = { desc = nil, autocmds = { "TextChanged" } }
local utility = require("src.utility")

local minimal_keys = { "initial_buffer", "new_buffer", "desc", "cursor_position" }

local buffer_data = {}

function buffer_permutation_task.init()
	buffer_data = utility.read_buffer_source_file("./buffer_data/test.buffer")
	for _, v in pairs(minimal_keys) do
		if not buffer_data[v] then
			print("Missing key!")
		end
	end
	utility.replace_main_buffer_with_str(buffer_data["initial_buffer"])

	buffer_permutation_task.desc = buffer_data["desc"]
end

function buffer_permutation_task.failed()
	return false
end

function buffer_permutation_task.completed()
	local lines = vim.api.nvim_buf_line_count(0)
	local new_buffer_lines = vim.api.nvim_buf_get_lines(0, 0, lines, false)

	local target_str = utility.split_str(buffer_data["new_buffer"])

	local comparison = #target_str == #new_buffer_lines
	if comparison then
		for i, v in pairs(new_buffer_lines) do
			comparison = comparison and v == target_str[i]
		end
	end

	return comparison
end

function buffer_permutation_task.teardown() end

return buffer_permutation_task
