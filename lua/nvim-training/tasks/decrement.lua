local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")

local Decrement = {}
Decrement.__index = Decrement
setmetatable(Decrement, { __index = Task })
Decrement.metadata = {
	autocmd = "CursorMoved",
	desc = "Decrement the value at the cursor.",
	instructions = "Decrement the value at the cursor.",
	tags = { "increment", "change", "char" },
	input_template = "<C-x>",
}

function Decrement:new()
	local base = Task:new()
	setmetatable(base, { __index = Decrement })

	base.inital_value = 5
	base.updated_value = base.inital_value - 1
	return base
end
function Decrement:activate()
	local function _inner_update()
		local target_cursor_pos = 30
		local line = utility.construct_char_line(self.inital_value, 30)
		utility.set_buffer_to_rectangle_with_line(line)
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], target_cursor_pos - 1 })
	end
	vim.schedule_wrap(_inner_update)()
end

function Decrement:deactivate()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_line(cursor_pos[1])

	local char_at_cursor = line:sub(cursor_pos[2] + 1, cursor_pos[2] + 1)
	return tonumber(char_at_cursor) == self.updated_value
end

return Decrement
