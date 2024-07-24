local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")

--Todo: Rework this such that it does not require to leave insertmode

local InsertChar = {}
InsertChar.__index = InsertChar
setmetatable(InsertChar, { __index = Task })
InsertChar.__metadata = {
	autocmd = "InsertLeave",
	desc = "Insert a char at the current position.",
	instructions = "",
	tags = "change, insertion, char",
}

function InsertChar:new()
	local base = Task:new()
	setmetatable(base, { __index = InsertChar })
	return base
end

function InsertChar:activate()
	local function _inner_update()
		utility.set_buffer_to_rectangle_and_place_cursor_randomly()
	end
	vim.schedule_wrap(_inner_update)()
end
function InsertChar:deactivate(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_line(cursor_pos[1])
	local char_at_cursor = line:sub(cursor_pos[2] + 1, cursor_pos[2] + 1)
	return char_at_cursor == "x"
end
function InsertChar:instructions()
	return "Insert the character 'x' at the cursor and leave InsertMode."
end

return InsertChar
