local Task = require("nvim_training.task")
local utility = require("nvim_training.utility")
local MoveMarkTask = Task:new()
MoveMarkTask.base_args =
	{ chars = { "a", "b", "c", "d", "x", "y" }, tags = { "movement", "mark" }, autocmds = { "CursorMoved" } }

function MoveMarkTask:prepare()
	self:load_from_json("one_word_per_line.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)
	self:teardown_all_marks()
	self:place_mark()
end

function MoveMarkTask:place_mark()
	self.current_mark_name = self.chars[math.random(1, #self.chars)]

	local line_count = vim.api.nvim_buf_line_count(0)

	self.target_line = math.random(1, line_count - 5)
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	while current_line == self.target_line do
		self.target_line = math.random(1, line_count - 5)
	end

	local cursor_position = vim.api.nvim_win_get_cursor(0)[1]
	while target_line == cursor_position do
		self.target_line = math.random(5, 15)
	end
	self.desc = "Go to Mark " .. self.current_mark_name
	self.highlight_namespace = vim.api.nvim_create_namespace("MarkLineNameSpace")
	vim.api.nvim_set_hl(0, "UnderScore", { underline = true })

	vim.api.nvim_buf_add_highlight(0, self.highlight_namespace, "UnderScore", self.target_line - 1, 0, -1)

	vim.api.nvim_buf_set_mark(0, self.current_mark_name, self.target_line, 0, {})
end

function MoveMarkTask:completed()
	local cursor_position = vim.api.nvim_win_get_cursor(0)[1]
	local comparison = cursor_position == self.target_line
	return comparison
end

function MoveMarkTask:failed()
	return not self:completed()
end

function MoveMarkTask:teardown()
	if self.highlight_namespace then
		vim.api.nvim_buf_clear_namespace(0, self.highlight_namespace, 0, -1)
	end
	self:teardown_all_marks()
end
function MoveMarkTask:teardown_all_marks()
	for _, mark_el in pairs(self.chars) do
		vim.api.nvim_buf_set_mark(0, mark_el, 0, 0, {})
	end
end

return MoveMarkTask
