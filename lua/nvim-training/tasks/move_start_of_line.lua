local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")

local MoveStartOfLine = Task:new()

MoveStartOfLine.__index = MoveStartOfLine
function MoveStartOfLine:new()
	local base = Task:new()
	setmetatable(base, { __index = MoveStartOfLine })
	self.autocmd = "CursorMoved"

	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		if cursor_pos[2] == 0 then
			--This prevents starting in the first column
			vim.api.nvim_win_set_cursor(0, { cursor_pos[1], 1 })
		end
		utility.create_highlight(cursor_pos[1] - 1, 0, 1)
	end
	vim.schedule_wrap(_inner_update)()
	return base
end

function MoveStartOfLine:teardown(autocmd_callback_data)
	utility.clear_all_our_highlights()
	return vim.api.nvim_win_get_cursor(0)[2] == 0
end

function MoveStartOfLine:description()
	return "Move to the start of the line the cursor is in."
end

return MoveStartOfLine
