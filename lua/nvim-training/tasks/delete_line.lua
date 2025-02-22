local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")

local DeleteLine = {}
DeleteLine.__index = DeleteLine
setmetatable(DeleteLine, { __index = Delete })
DeleteLine.metadata = {
	autocmd = "TextChanged",
	desc = "Delete the current line.",
	instructions = "Delete the current line.",
	tags = { "deletion", "line" },
	input_template = "dd",
	--todo: Register support
}

function DeleteLine:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteLine })
	return base
end

function DeleteLine:activate()
	local function _inner_update()
		local random_line = utility.load_random_line()
		utility.set_buffer_to_rectangle_with_line(random_line)

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		local line = utility.get_line(cursor_pos[1])
		self.target_text = line
		utility.construct_highlight(cursor_pos[1], 0, #self.target_text)
	end
	vim.schedule_wrap(_inner_update)()
end

return DeleteLine
