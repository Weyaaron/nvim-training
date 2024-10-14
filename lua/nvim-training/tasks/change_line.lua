local utility = require("nvim-training.utility")
local Change = require("nvim-training.tasks.change")

local ChangeLine = {}
ChangeLine.__index = ChangeLine
ChangeLine.__metadata = {
	autocmd = "InsertLeave",
	desc = "Change the current line.",
	instructions = "Change the current line into 'x' and leave insert-mode.",
	tags = "deletion, line, change",
}

setmetatable(ChangeLine, { __index = Change })
function ChangeLine:new()
	local base = Change:new()
	setmetatable(base, { __index = ChangeLine })
	return base
end

function ChangeLine:activate()
	local function _inner_update()
		local random_line = utility.load_random_line()
		utility.set_buffer_to_rectangle_with_line(random_line)

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		utility.construct_highlight(cursor_pos[1], 0, #self.text_to_be_inserted)

		self.line_text_after_change = "x"
		self.cursor_target = { cursor_pos[1], 0 }
	end
	vim.schedule_wrap(_inner_update)()
end

return ChangeLine
