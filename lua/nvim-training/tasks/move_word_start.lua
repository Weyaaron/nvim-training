local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local MoveWordStart = {}
MoveWordStart.__index = MoveWordStart
setmetatable(MoveWordStart, { __index = Move })
MoveWordStart.metadata = {
	autocmd = "CursorMoved",
	desc = "Move back to the start of 'words'.",
	instructions = "",
	tags = utility.flatten({ tag_index.movement, tag_index.word_start }),
}

function MoveWordStart:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveWordStart })
	return base
end
function MoveWordStart:activate()
	local function _inner_update()
		local line = utility.construct_words_line()
		utility.set_buffer_to_rectangle_with_line(line)

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], 55 })

		local new_x_pos = movements.word_start(line, current_cursor_pos[2], self.counter)
		self.cursor_target = { current_cursor_pos[1], new_x_pos }
		utility.construct_highlight(current_cursor_pos[1], self.cursor_target[2], 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveWordStart:instructions()
	return "Move 'back' to the start of the " .. self.counter .. " 'word'."
end

return MoveWordStart
