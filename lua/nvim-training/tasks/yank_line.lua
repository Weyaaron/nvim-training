local utility = require("nvim-training.utility")
local Yank = require("nvim-training.tasks.yank")

local YankLine = {}
YankLine.__index = YankLine

YankLine.metadata = {
	autocmd = "TextYankPost",
	desc = "Yank a line into a register.",
	instructions = "",
	tags = { "register", "copy", "line", "vertical" },
}

setmetatable(YankLine, { __index = Yank })
function YankLine:new()
	local base = Yank:new()
	setmetatable(base, YankLine)
	return base
end
function YankLine:activate()
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()

		local cursor_pos = vim.api.nvim_win_get_cursor(0)

		local current_line = utility.get_line(cursor_pos[1])
		local line_length = #current_line
		utility.construct_highlight(cursor_pos[1], 0, line_length)
		self.target_text = current_line
	end
	vim.schedule_wrap(_inner_update)()
end

function YankLine:instructions()
	return "Yank the current line" .. utility.construct_register_description(self.target_register) .. "."
end

return YankLine
