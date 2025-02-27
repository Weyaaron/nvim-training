local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")

local Toggle = {}
Toggle.__index = Toggle
Toggle.metadata = {
	autocmd = "CursorMoved",
	desc = "Toggle the value at the cursor.",
	instructions = "Toggle the value at the cursor.",
	tags = { "toggle" },
}

setmetatable(Toggle, { __index = Task })
function Toggle:new()
	local base = Task:new()
	setmetatable(base, { __index = Toggle })

	base.inital_value = "true"
	base.updated_value = "false"
	return base
end
function Toggle:activate()
	local function _inner_update()
		local target_cursor_pos = 30
		local line = utility.construct_char_line(self.inital_value, 30)
		utility.set_buffer_to_rectangle_with_line(line)
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], target_cursor_pos - 1 })
	end
	vim.schedule_wrap(_inner_update)()
end

function Toggle:deactivate()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_line(cursor_pos[1])
	return line:find(self.updated_value)
end

return Toggle
