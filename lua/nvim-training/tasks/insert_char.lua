local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")

local InsertChar = {}
InsertChar.__index = InsertChar
setmetatable(InsertChar, { __index = Task })
InsertChar.metadata = {
	autocmd = "InsertLeave",
	desc = "Insert a char at the current position.",
	instructions = "",
	tags = { "change", "insertion", "char" },
	input_template = "ix<esc>",
}

function InsertChar:new()
	local base = Task:new()
	setmetatable(base, { __index = InsertChar })
	return base
end

function InsertChar:activate()
	local function _inner_update()
		local random_line = utility.load_random_line()
		utility.set_buffer_to_rectangle_with_line(random_line)
	end
	vim.schedule_wrap(_inner_update)()
end
function InsertChar:deactivate()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_line(cursor_pos[1])
	local char_at_cursor = line:sub(cursor_pos[2] + 1, cursor_pos[2] + 1)
	return char_at_cursor == "x"
end
function InsertChar:instructions()
	return "Insert the character 'x' at the cursor and leave InsertMode."
end

return InsertChar
