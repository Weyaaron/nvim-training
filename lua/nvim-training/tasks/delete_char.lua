local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local tag_index = require("nvim-training.tag_index")

local DeleteCharTask = {}
DeleteCharTask.__index = DeleteCharTask
setmetatable(DeleteCharTask, { __index = Task })
DeleteCharTask.metadata = {
	autocmd = "TextChanged",
	desc = "Delete the current char.",
	instructions = "Delete the current char.",
	tags = utility.flatten({ tag_index.change, "char" }),
	input_template = "x",
}

function DeleteCharTask:new()
	local base = Task:new()
	setmetatable(base, { __index = DeleteCharTask })
	return base
end

function DeleteCharTask:activate()
	local function _inner_update()
		local random_line = utility.load_random_line()
		utility.set_buffer_to_rectangle_with_line(random_line)

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		local line = utility.get_line(cursor_pos[1])
		self.line_length = #line
	end
	vim.schedule_wrap(_inner_update)()
end
function DeleteCharTask:deactivate()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line_length = #utility.get_line(cursor_pos[1])
	return self.line_length - 1 == line_length
end

return DeleteCharTask
