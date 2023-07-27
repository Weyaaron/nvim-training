local Task = require("nvim_training.task")

local AbsoluteLineTask = Task:new()
local utility = require("nvim_training.utility")

AbsoluteLineTask.base_args = { tags = { "movement", "line_based" }, autocmds = { "CursorMoved" } }

function AbsoluteLineTask:prepare()
	self:load_from_json("absolute_line.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)

	local line_count = vim.api.nvim_buf_line_count(0)

	self.target_line = math.random(1, line_count - 5)
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	while current_line == self.target_line do
		self.target_line = math.random(1, line_count - 5)
	end

	self.desc = "Move to line " .. tostring(self.target_line)
	self.highlight_namespace = vim.api.nvim_create_namespace("AbsoluteVerticalLineNameSpace")

	vim.api.nvim_set_hl(0, "UnderScore", { underline = true })

	vim.api.nvim_buf_add_highlight(0, self.highlight_namespace, "UnderScore", self.target_line - 1, 0, -1)
end

function AbsoluteLineTask:completed()
	local cursor_position = vim.api.nvim_win_get_cursor(0)[1]
	local comparison = cursor_position == self.target_line
	return comparison
end

function AbsoluteLineTask:failed()
	return not self:completed()
end

function AbsoluteLineTask:teardown()
	if self.highlight_namespace then
		vim.api.nvim_buf_clear_namespace(0, self.highlight_namespace, 0, -1)
	end
end

return AbsoluteLineTask
