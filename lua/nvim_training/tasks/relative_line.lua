local utility = require("nvim_training.utility")
local Task = require("nvim_training.task")

local RelativeLineTask = Task:new()
RelativeLineTask.base_args = { tags = { "movement", "relative" } }

function RelativeLineTask:prepare()
	self:load_from_json("relative_line.buffer")
	self.previous_line = 0

	self.current_offset = utility.draw_random_number_with_sign(2, 9)
	self.previous_line = vim.api.nvim_win_get_cursor(0)[1]

	while self.current_offset + self.previous_line < 0 do
		self.current_offset = utility.draw_random_number_with_sign(2, 9)
	end

	self.desc = "Move " .. tostring(self.current_offset) .. " lines relative to your cursor."

	self.highlight_namespace = vim.api.nvim_create_namespace("RelativeVerticalLineNameSpace")

	vim.api.nvim_set_hl(0, "UnderScore", { underline = true })

	local line_for_highlight = self.previous_line + self.current_offset - 1
	vim.api.nvim_buf_add_highlight(0, self.highlight_namespace, "UnderScore", line_for_highlight, 0, -1)
end

function RelativeLineTask:completed()
	return vim.api.nvim_win_get_cursor(0)[1] == self.previous_line + self.current_offset
end

function RelativeLineTask:failed()
	return not self:completed()
end

function RelativeLineTask:teardown()
	if self.highlight_namespace then
		vim.api.nvim_buf_clear_namespace(0, self.highlight_namespace, 0, -1)
	end
end

return RelativeLineTask
