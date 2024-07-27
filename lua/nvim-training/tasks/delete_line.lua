local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")
local Delete = require("nvim-training.tasks.delete")

local DeleteLineTask = {}
DeleteLineTask.__index = DeleteLineTask

DeleteLineTask.__metadata = {
	autocmd = "TextChanged",
	desc = "Delete the current line.",
	instructions = "Delete the current line.",
	tags = "deletion, line, change",
}

setmetatable(DeleteLineTask, { __index = Delete })
function DeleteLineTask:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteLineTask })
	return base
end

function DeleteLineTask:activate()
	local function _inner_update()
		utility.set_buffer_to_rectangle_and_place_cursor_randomly()
		local line = utility.get_current_line()
		self.target_text = line
	end
	vim.schedule_wrap(_inner_update)()
end

return DeleteLineTask
