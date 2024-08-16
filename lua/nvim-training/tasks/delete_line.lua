local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")

local DeleteLine = {}
DeleteLine.__index = DeleteLine

DeleteLine.__metadata = {
	autocmd = "TextChanged",
	desc = "Delete the current line.",
	instructions = "Delete the current line.",
	tags = "deletion, line, change",
}

setmetatable(DeleteLine, { __index = Delete })
function DeleteLine:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteLine })
	return base
end

function DeleteLine:activate()
	local function _inner_update()
		utility.set_buffer_to_rectangle_and_place_cursor_randomly()
		local line = utility.get_current_line()
		self.target_text = line
	end
	vim.schedule_wrap(_inner_update)()
end

return DeleteLine
