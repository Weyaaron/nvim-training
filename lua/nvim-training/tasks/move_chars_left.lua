local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")

local MoveCharsLeft = {}
setmetatable(MoveCharsLeft, { __index = Move })
MoveCharsLeft.__index = MoveCharsLeft

MoveCharsLeft.metadata = {
	autocmd = "CursorMoved",
	desc = "Move left charwise.",
	instructions = "",
	tags = { "movement", "h", "horizontal", "char" },
	input_template = "<counter>h",
}

function MoveCharsLeft:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveCharsLeft })
	return base
end
function MoveCharsLeft:activate()
	local function _inner_update()
		local line = utility.construct_words_line()
		utility.set_buffer_to_rectangle_with_line(line)
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		local new_y = cursor_pos[2] - self.counter
		self.cursor_target = { cursor_pos[1], new_y }
		utility.construct_highlight(cursor_pos[1], new_y, 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveCharsLeft:instructions()
	return "Move " .. self.counter .. " char(s) left."
end
return MoveCharsLeft
