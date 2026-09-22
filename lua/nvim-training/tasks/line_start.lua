local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")
local StaticSolution = require("nvim-training.tasks.task_with_static_solution")

local MoveLineTextStart = {}
MoveLineTextStart.__index = setmetatable(MoveLineTextStart, { __index = StaticSolution })
MoveLineTextStart.metadata = {
	autocmd = "CursorMoved",
	desc = "Move to the start of text in the current line.",
	instructions = "",
	tags = utility.flatten({ tag_index.movement }),
	input_template = "",
}

function MoveLineTextStart:new()
	local base = StaticSolution:new()
	setmetatable(base, { __index = StaticSolution })
	return base
end
function MoveLineTextStart:activate()
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

function MoveLineTextStart:instructions()
	return "Move to the start of the text in the current line"
end

return MoveLineTextStart
