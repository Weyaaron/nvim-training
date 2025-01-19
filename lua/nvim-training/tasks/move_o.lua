local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local tag_index = require("nvim-training.tag_index")

local Moveo = {}
Moveo.__index = Moveo
setmetatable(Moveo, { __index = Move })
Moveo.__metadata = {
	autocmd = "InsertLeave",
	desc = "Enter and leave insert mode below the current line.",
	instructions = "Enter and leave insert mode below the current line.",
	tags = Move.__metadata.tags .. tag_index.o,
}

function Moveo:new()
	local base = Move:new()
	setmetatable(base, { __index = Moveo })
	return base
end

function Moveo:activate()
	local function _inner_update()
		local random_line = utility.load_random_line()
		utility.set_buffer_to_rectangle_with_line(random_line)
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		self.cursor_target = { cursor_pos[1] + 1, 0 }
	end
	vim.schedule_wrap(_inner_update)()
end

return Moveo
