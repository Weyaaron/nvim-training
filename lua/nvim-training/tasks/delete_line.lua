local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")

local DeleteLineTask = {}
DeleteLineTask.__index = DeleteLineTask

DeleteLineTask.__metadata = {
	autocmd = "TextChanged",
	desc = "Delete the current line.",
	instructions = "Delete the current line.",
	tags = "deletion, line",
}

setmetatable(DeleteLineTask, { __index = Task })
function DeleteLineTask:new()
	local base = Task:new()
	setmetatable(base, { __index = DeleteLineTask })
	return base
end

function DeleteLineTask:activate()
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
		self.line_length = vim.api.nvim_buf_line_count(0)
	end
	vim.schedule_wrap(_inner_update)()
end
function DeleteLineTask:deactivate(autocmd_callback_data)
	return vim.api.nvim_buf_line_count(0) == self.line_length - 1
end

return DeleteLineTask
