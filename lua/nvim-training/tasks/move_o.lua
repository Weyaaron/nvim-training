local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")

local Move_o = {}
Move_o.__index = Move_o
setmetatable(Move_o, { __index = Move })
Move_o.__metadata = {
	autocmd = "InsertLeave",
	desc = "Enter and leave insert mode below the current line.",
	instructions = "Enter and leave insert mode below the current line.",
	tags = "o, movement, insert_mode, linewise",
}

function Move_o:new()
	local base = Move:new()
	setmetatable(base, { __index = Move_o })
	return base
end

function Move_o:activate()
	local function _inner_update()
		utility.set_buffer_to_rectangle_and_place_cursor_randomly()

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		self.cursor_target = { cursor_pos[1] + 1, 0 }
	end
	vim.schedule_wrap(_inner_update)()
end

return Move_o
