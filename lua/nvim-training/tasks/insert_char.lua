local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")

local InsertChar = {}
InsertChar.__index = InsertChar

--Todo: Update once implementation work
InsertChar.__metadata = { autocmd = "TextChangedI", desc = "Insert char", instruction = "Move" }

function InsertChar:new()
	local base = Task:new()
	setmetatable(base, { __index = InsertChar })

	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
	end
	vim.schedule_wrap(_inner_update)()
	return base

	--Todo: Debug the weird behavior on chang event
end
function InsertChar:deactivate(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_line(cursor_pos[1])
	local char_at_cursor = line:sub(cursor_pos[2], cursor_pos[2])
	print("c" .. tostring(char_at_cursor))
	return char_at_cursor == "x"
end
function InsertChar:description()
	return "Insert the character 'x' at the cursor and leave InsertMode."
end

return InsertChar
