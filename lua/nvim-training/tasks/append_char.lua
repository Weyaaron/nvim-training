local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")

local AppendChar = {}
AppendChar.__index = AppendChar
setmetatable(AppendChar, { __index = Task })
AppendChar.__metadata = {
	autocmd = "InsertLeave",
	desc = "Insert a char next to the cursor.",
	instructions = "",
	tags = "change, insertion, append",
}

function AppendChar:new()
	local base = Task:new()
	setmetatable(base, { __index = AppendChar })
	return base
end

function AppendChar:activate()
	local function _inner_update()
		utility.set_buffer_to_rectangle_and_place_cursor_randomly()
	end
	vim.schedule_wrap(_inner_update)()
end
function AppendChar:deactivate(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_line(cursor_pos[1])
	local char_at_cursor = line:sub(cursor_pos[2] + 1, cursor_pos[2] + 1)

	return char_at_cursor == "x"
end
function AppendChar:instructions()
	return "Insert the character 'x' next to the cursor and leave InsertMode."
end

return AppendChar
