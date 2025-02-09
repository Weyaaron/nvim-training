local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local movements = require("nvim-training.movements")
local user_config = require("nvim-training.user_config")
local internal_config = require("nvim-training.internal_config")
local tag_index = require("nvim-training.tag_index")

local MoveWordEnd = {}
MoveWordEnd.__index = MoveWordEnd
setmetatable(MoveWordEnd, { __index = Move })
MoveWordEnd.metadata = {
	autocmd = "CursorMoved",
	desc = "Move to the end of words.",
	instructions = "Move to the end of the current 'word'.",
	tags = utility.flatten({ tag_index.movement, tag_index.word_end }),
}

function MoveWordEnd:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveWordEnd })

	base.counter = 1
	if user_config.enable_counters then
		base.counter = math.random(2, 4)
	end
	return base
end
function MoveWordEnd:activate()
	local function _inner_update()
		local word_line = utility.construct_words_line()

		word_line = word_line:sub(0, internal_config.line_length)
		utility.set_buffer_to_rectangle_with_line(word_line)

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], math.random(1, 10) })

		current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		local new_x_pos = movements.word_end(word_line, current_cursor_pos[2], self.counter)
		self.cursor_target = { current_cursor_pos[1], new_x_pos }
		utility.construct_highlight(current_cursor_pos[1], self.cursor_target[2], 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveWordEnd:instructions()
	return "Move to the end of " .. self.counter .. " 'words'."
end
return MoveWordEnd
