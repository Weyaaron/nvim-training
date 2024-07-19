local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")

local DeleteLineTask = Task:new()
DeleteLineTask.__index = DeleteLineTask

function DeleteLineTask:new()
	local base = Task:new()
	setmetatable(base, { __index = DeleteLineTask })
	base.autocmd = "TextChanged"

	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
		base.line_length = vim.api.nvim_buf_line_count(0)
	end
	vim.schedule_wrap(_inner_update)()
	return base
end
function DeleteLineTask:deactivate(autocmd_callback_data)
	return vim.api.nvim_buf_line_count(0) == self.line_length - 1
end
function DeleteLineTask:description()
	return "Delete the current line."
end

return DeleteLineTask
