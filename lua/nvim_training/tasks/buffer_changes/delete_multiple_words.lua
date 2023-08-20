-- luacheck: globals vim

local Task = require("nvim_training.task")

local DeleteMultipleWordsTask = Task:new()
DeleteMultipleWordsTask.base_args = { autocmds = { "TextChanged" }, tags = { "buffer" } }
local utility = require("nvim_training.utility")

function DeleteMultipleWordsTask:prepare()
	self:load_from_json("numbers.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)
	self.target_buffer = self.initial_buffer

	self.buffer_as_list = utility.construct_linked_list()
	local offset = math.random(2, 12)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local move_to_cursor = self.buffer_as_list:traverse_to_line_char(cursor_pos[1], cursor_pos[2])
	local movement_result = move_to_cursor:w(offset)

	self.desc = "Remove " .. offset .. " words."

	local new_list = move_to_cursor:consume_up_until_node_inclusive(movement_result)
	self.target_list = new_list

	self.highlight_namespace = vim.api.nvim_create_namespace("BufferPermutationNameSpace")

	vim.api.nvim_set_hl(0, "UnderScore", { underline = true })

	vim.api.nvim_buf_add_highlight(
		0,
		self.highlight_namespace,
		"UnderScore",
		movement_result.line_index - 1,
		movement_result.end_index,
		movement_result.end_index + 1
	)
end

function DeleteMultipleWordsTask:completed()
	local line_count = vim.api.nvim_buf_line_count(0)
	local current_buffer_lines = vim.api.nvim_buf_get_lines(0, 0, line_count, false)

	local target_lines = utility.deconstruct_linked_list(self.target_list)
	local comparison = #target_lines == #current_buffer_lines
	if not comparison then
		print("Lines differ in length!")
	end

	for i, current_buffer_line_el in pairs(current_buffer_lines) do
		local target_line_el = target_lines[i]
		local line_comparision = target_line_el == current_buffer_line_el
		if not line_comparision then
			print("Comp broke at " .. i .. ":" .. current_buffer_line_el .. "!=" .. target_line_el)
			comparison = false
			break
		end
	end

	return comparison
end

function DeleteMultipleWordsTask:failed()
	return not self:completed()
end

function DeleteMultipleWordsTask:teardown()
	if self.highlight_namespace then
		vim.api.nvim_buf_clear_namespace(0, self.highlight_namespace, 0, -1)
	end
end

return DeleteMultipleWordsTask
