local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")

local DeleteCharTask = {}
DeleteCharTask.__index = DeleteCharTask
DeleteCharTask.__metadata = {
	autocmd = "TextChanged",
	desc = "Delete the char at the cursor.",
	instructions = "Delete the char at the cursor.",
}

setmetatable(DeleteCharTask, { __index = Task })
function DeleteCharTask:new()
	local base = Task:new()
	setmetatable(base, { __index = DeleteCharTask })
	return base
end

function DeleteCharTask:activate()
	local function _inner_update()
		utility.set_buffer_to_rectangle_and_place_cursor_randomly()
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		local line = utility.get_line(cursor_pos[1])
		self.line_length = #line
	end
	vim.schedule_wrap(_inner_update)()
end
function DeleteCharTask:deactivate(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line_length = #utility.get_line(cursor_pos[1])
	return self.line_length - 1 == line_length
end

return DeleteCharTask
