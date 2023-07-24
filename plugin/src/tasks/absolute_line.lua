local MovementTask = require("plugin.src.tasks.movement_task")
local AbsoluteLineTask = MovementTask:new()

function AbsoluteLineTask:prepare()
	self.target_line = math.random(1, 15)
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
