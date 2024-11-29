local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local internal_config = require("nvim-training.internal_config")
local movements = require("nvim-training.movements")

local MoveWORDEnd = {}
MoveWORDEnd.__index = MoveWORDEnd
setmetatable(MoveWORDEnd, { __index = Move })
MoveWORDEnd.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move to the end of WORDs.",
	instructions = "",
	tags = "movement, word, end, vertical",
}

function MoveWORDEnd:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveWORDEnd })
	return base
end
function MoveWORDEnd:activate()
	local function _inner_update()
		local word_line = utility.construct_WORDS_line()
		word_line = word_line:sub(0, internal_config.line_length)
		utility.set_buffer_to_rectangle_with_line(word_line)

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], math.random(1, 10) })

		current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		local new_x_pos = movements.WORD_end(word_line, current_cursor_pos[2], self.counter)
		self.cursor_target = { current_cursor_pos[1], new_x_pos }
		utility.construct_highlight(current_cursor_pos[1], self.cursor_target[2], 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveWORDEnd:instructions()
	return "Move to the end of " .. self.counter .. " 'WORDS'."
end

return MoveWORDEnd
