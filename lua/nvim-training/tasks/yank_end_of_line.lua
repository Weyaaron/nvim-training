local utility = require("nvim-training.utility")
local Yank = require("nvim-training.tasks.yank")

local YankEndOfLine = {}
YankEndOfLine.__index = YankEndOfLine

YankEndOfLine.metadata = {
	autocmd = "TextYankPost",
	desc = "Yank to the end of the current line.",
	instructions = "",
	tags = { "end", "line", "yank" },
}

setmetatable(YankEndOfLine, { __index = Yank })
function YankEndOfLine:new()
	local base = Yank:new()
	setmetatable(base, { __index = YankEndOfLine })
	return base
end
function YankEndOfLine:activate()
	local function _inner_update()
		local random_line = utility.load_random_line()
		utility.set_buffer_to_rectangle_with_line(random_line)
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		local line = utility.get_line(cursor_pos[1])
		self.target_text = string.sub(line, cursor_pos[2] + 1, #line)
		utility.construct_highlight(cursor_pos[1], cursor_pos[2], math.abs(#line - cursor_pos[2]))
	end
	vim.schedule_wrap(_inner_update)()
end

function YankEndOfLine:instructions()
	return "Yank to the end of the line" .. utility.construct_register_description(self.target_register) .. "."
end

return YankEndOfLine
