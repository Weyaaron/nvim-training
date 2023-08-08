local Task = require("nvim_training.task")

local MoveRandomXYTask = Task:new()
local utility = require("nvim_training.utility")

MoveRandomXYTask.base_args = { tags = { "movement", "line_based" }, autocmds = { "CursorMoved" } }

function MoveRandomXYTask:prepare()
	--Todo: Improve Highlight Visibility
	self:load_from_json("lorem_ipsum.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)

	local line_count = vim.api.nvim_buf_line_count(0)

	self.target_line = math.random(1, line_count - 5)
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	while current_line == self.target_line do
		self.target_line = math.random(1, line_count - 5)
	end

	local line_len = self:construct_line_table_from_buffer()[self.target_line]
	line_len = string.len(line_len)

	self.target_char = math.random(1, line_len - 2)

	self.desc = "Move to line " .. tostring(self.target_line) .. " and char " .. self.target_char
	self.highlight_namespace = vim.api.nvim_create_namespace("AbsoluteVerticalLineNameSpace")

	vim.api.nvim_set_hl(0, "UnderScore", { underline = true })

	vim.api.nvim_buf_add_highlight(
		0,
		self.highlight_namespace,
		"UnderScore",
		self.target_line - 1,
		self.target_char,
		self.target_char + 1
	)
end

function MoveRandomXYTask:completed()
	local cursor_position_x_y = vim.api.nvim_win_get_cursor(0)
	local x_comparison = cursor_position_x_y[1] == self.target_line
	local y_comparison = cursor_position_x_y[2] == self.target_char
	return x_comparison and y_comparison
end

function MoveRandomXYTask:construct_line_table_from_buffer()
	local line_count = vim.api.nvim_buf_line_count(0)
	return vim.api.nvim_buf_get_lines(0, 0, line_count, false)
end

function MoveRandomXYTask:failed()
	return not self:completed()
end

function MoveRandomXYTask:teardown()
	if self.highlight_namespace then
		vim.api.nvim_buf_clear_namespace(0, self.highlight_namespace, 0, -1)
	end
end

return MoveRandomXYTask
