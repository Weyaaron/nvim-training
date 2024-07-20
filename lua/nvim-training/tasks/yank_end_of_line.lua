local utility = require("nvim-training.utility")
local internal_config = require("nvim-training.internal_config")
local TaskYank = require("nvim-training.tasks.task_yank")

local YankEndOfLine = {}
YankEndOfLine.__index = YankEndOfLine

YankEndOfLine.__metadata = {
	autocmd = "TextYankPost",
	desc = "Yank to the end of the current line.",
	instructions = "Yank to the end of the current line.",
}

setmetatable(YankEndOfLine, { __index = TaskYank })
function YankEndOfLine:new()
	local base = TaskYank:new()
	setmetatable(base, { __index = YankEndOfLine })
	base.chosen_register = '"'
	return base
end
function YankEndOfLine:activate()
	local function _inner_update()
		utility.set_buffer_to_rectangle_and_place_cursor_randomly()
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		local line = utility.get_line(cursor_pos[1])
		self.target_text = string.sub(line, cursor_pos[2] + 1, #line)
	end
	vim.schedule_wrap(_inner_update)()
end

return YankEndOfLine
