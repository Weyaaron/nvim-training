local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local MoveWord = {}
MoveWord.__index = MoveWord
setmetatable(MoveWord, { __index = Move })
MoveWord.metadata = {
	autocmd = "CursorMoved",
	desc = "Move multiple words.",
	instructions = "",
	tags = utility.flatten({ tag_index.movement, tag_index.word }),
	input_template = "<counter>w",
}

function MoveWord:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveWord })

	return base
end

function MoveWord:activate()
	local function _inner_update()
		local line = utility.construct_words_line()
		utility.set_buffer_to_rectangle_with_line(line)
		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		local start_pos = math.random(20, 25)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], start_pos })
		current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		self.cursor_target = { current_cursor_pos[1], movements.words(line, current_cursor_pos[2], self.counter) }
		utility.construct_highlight(current_cursor_pos[1], self.cursor_target[2], 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveWord:instructions()
	return "Move " .. self.counter .. " word(s)."
end

return MoveWord
