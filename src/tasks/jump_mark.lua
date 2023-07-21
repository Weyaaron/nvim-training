local JumpMarkTask = {}

local Task = require("src.task")

function JumpMarkTask:new()
	local newObj = Task:new()
	self.__index = self
	setmetatable(newObj, self)
	newObj:place_mark()

	return newObj
end

function JumpMarkTask:place_mark()
	local chars = { "a", "b", "c", "d", "x", "y" }
	self.current_mark_name = chars[math.random(1, #chars)]

	self.target_line = math.random(5, 15)
	self.desc = "Go to Mark " .. self.current_mark_name
	self.highlight_namespace = vim.api.nvim_create_namespace("MarkLineNameSpace")
	vim.api.nvim_set_hl(0, "UnderScore", { underline = true })

	vim.api.nvim_buf_add_highlight(0, self.highlight_namespace, "UnderScore", self.target_line - 1, 0, -1)

	vim.api.nvim_buf_set_mark(0, self.current_mark_name, self.target_line, 0, {})
end
function JumpMarkTask:prepare()
	self:place_mark()
end

function JumpMarkTask:completed()
	local cursor_position = vim.api.nvim_win_get_cursor(0)[1]
	local comparison = cursor_position == self.target_line
	return comparison
end

function JumpMarkTask:failed()
	return not self:completed()
end

function JumpMarkTask:teardown()
	if self.highlight_namespace then
		vim.api.nvim_buf_clear_namespace(0, self.highlight_namespace, 0, -1)
	end
	vim.api.nvim_buf_set_mark(0, self.current_mark_name, 0, 0, {})
end

return JumpMarkTask
