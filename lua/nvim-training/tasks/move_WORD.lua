local Move = require("nvim-training.tasks.move")
local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")
local internal_config = require("nvim-training.internal_config")

local MoveWORD = {}
MoveWORD.__index = MoveWORD
setmetatable(MoveWORD, { __index = Move })
MoveWORD.__metadata =
	{ autocmd = "CursorMoved", desc = "Move using W.", instructions = "Move using W.", tags = "movement, W, WORD" }

function MoveWORD:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveWORD })

	return base
end

function MoveWORD:activate()
	local function _inner_update()
		local word_line = utility.construct_WORDS_line()
		word_line = word_line:sub(0, internal_config.line_length)
		utility.set_buffer_to_rectangle_with_line(word_line)

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], math.random(1, 10) })

		self.cursor_target = movements.WORDS(self.counter)
		utility.create_highlight(current_cursor_pos[1] - 1, self.cursor_target[2], 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveWORD:instructions()
	return "Move " .. self.counter .. " WORD(s) using 'W'."
end
return MoveWORD
