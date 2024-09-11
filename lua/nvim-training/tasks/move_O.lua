local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")

local Move_O = {}
Move_O.__index = Move_O
setmetatable(Move_O, { __index = Move })
Move_O.__metadata = {
	autocmd = "InsertLeave",
	desc = "Enter and leave insert mode above the current line.",
	instructions = "Enter and leave insert mode above the current line.",
	tags = "O, movement, insert_mode, linewise",
}

function Move_O:new()
	local base = Move:new()
	setmetatable(base, { __index = Move_O })
	return base
end

function Move_O:activate()
	local function _inner_update()
		local random_line = utility.load_random_line()
		utility.set_buffer_to_rectangle_with_line(random_line)
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		self.cursor_target = { cursor_pos[1] - 1, 0 }
	end
	vim.schedule_wrap(_inner_update)()
end

return Move_O
