local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local tag_index = require("nvim-training.tag_index")

local MoveO = {}
MoveO.__index = MoveO
setmetatable(MoveO, { __index = Move })
MoveO.__metadata = {
	autocmd = "InsertLeave",
	desc = "Enter and leave insert mode above the current line.",
	instructions = "Enter and leave insert mode above the current line.",
	tags = Move.__metadata.tags .. tag_index.O,
}

function MoveO:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveO })
	return base
end

function MoveO:activate()
	local function _inner_update()
		local random_line = utility.load_random_line()
		utility.set_buffer_to_rectangle_with_line(random_line)
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		self.cursor_target = { cursor_pos[1] - 1, 0 }
	end
	vim.schedule_wrap(_inner_update)()
end

return MoveO
