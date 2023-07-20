local RelativeLineTask = {}

local utility = require("src.utility")
local Task = require('src.task')

function RelativeLineTask:new()
	local newObj = Task:new()
	self.__index = self
	setmetatable(newObj, self)

	newObj.previous_line = 0
	newObj.target_offset = 0

	local current_offset = utility.draw_random_number_with_sign(2, 5)
	newObj.previous_line = vim.api.nvim_win_get_cursor(0)[1]

	newObj.desc = "Move " .. tostring(current_offset) .. " lines relative to your cursor."

	newObj.highlight_namespace = vim.api.nvim_create_namespace("RelativeVerticalLineNameSpace")

	vim.api.nvim_set_hl(0, "UnderScore", { underline = true })

	--Todo: Fix this weird highlight, in particular its index
	vim.api.nvim_buf_add_highlight(0, newObj.highlight_namespace, "UnderScore", 10, 0, -1)
	newObj.target_offset = current_offset
	return newObj
end
function RelativeLineTask:teardown()
	if self.highlight_namespace then
		vim.api.nvim_buf_clear_namespace(0, self.highlight_namespace, 0, -1)
	end
end

function RelativeLineTask:failed()
	return not self:completed()
end

function RelativeLineTask:completed()
	local target_line = self.previous_line + self.target_offset
	return vim.api.nvim_win_get_cursor(0)[1] == target_line
end

return RelativeLineTask
