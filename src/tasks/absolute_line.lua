local AbsoluteLineTask = {}

local Task = require("src.task")

function AbsoluteLineTask:new()
	local newObj = Task:new()
	self.__index = self
	setmetatable(newObj, self)

	return newObj
end
function AbsoluteLineTask:prepare()
	stelf.target_line = math.random(1, 15)
	stelf.desc = "Move to line " .. tostring(stelf.target_line)
	stelf.highlight_namespace = vim.api.nvim_create_namespace("AbsoluteVerticalLineNameSpace")

	vim.api.nvim_set_hl(0, "UnderScore", { underline = true })

	vim.api.nvim_buf_add_highlight(0, stelf.highlight_namespace, "UnderScore", stelf.target_line - 1, 0, -1)
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
