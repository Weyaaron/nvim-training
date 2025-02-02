local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")

local Increment = {}
Increment.__index = Increment
Increment.metadata = {
	autocmd = "CursorMoved",
	desc = "Increment the value at the cursor.",
	instructions = "Increment/Decrement the value at the cursor.",
	tags = { "increment", "change", "char" },
}

setmetatable(Increment, { __index = Task })
function Increment:new()
	local base = Task:new()
	setmetatable(base, { __index = Increment })

	local modes = { "Increment", "Decrement" }
	base.inital_value = 5
	base.mode = modes[math.random(#modes)]
	if base.mode == "Increment" then
		base.updated_value = base.inital_value + 1
	else
		base.updated_value = base.inital_value - 1
	end
	return base
end
function Increment:activate()
	local function _inner_update()
		local target_cursor_pos = 30
		local line = utility.construct_char_line(self.inital_value, 30)
		utility.set_buffer_to_rectangle_with_line(line)
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], target_cursor_pos - 1 })
	end
	vim.schedule_wrap(_inner_update)()
end

function Increment:deactivate()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_line(cursor_pos[1])

	local char_at_cursor = line:sub(cursor_pos[2] + 1, cursor_pos[2] + 1)
	return tonumber(char_at_cursor) == self.updated_value
end

function Increment:instructions()
	return self.mode .. " the number at the cursor."
end

return Increment
