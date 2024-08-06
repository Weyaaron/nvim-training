local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local user_config = require("nvim-training.user_config")
local movements = require("nvim-training.movements")
local MoveWord = {}

MoveWord.__index = MoveWord
setmetatable(MoveWord, { __index = Move })
MoveWord.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move using w.",
	instructions = "Move using w.",
	tags = "movement, word, horizontal, w",
}

function MoveWord:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveWord })
	base.target_y_pos = 0

	base.counter = 1
	if user_config.enable_counters then
		base.counter = math.random(2, 7)
	end

	base.cursor_target = { 0, 0 }
	return base
end

function MoveWord:activate()
	local function _inner_update()
		local cursor_at_line_start = false
		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		while not cursor_at_line_start do
			utility.set_buffer_to_rectangle_and_place_cursor_randomly()
			current_cursor_pos = vim.api.nvim_win_get_cursor(0)
			cursor_at_line_start = current_cursor_pos[2] < 15

			local line = utility.get_line(current_cursor_pos[1])
			local char_at_cursor_pos = line:sub(current_cursor_pos[2] + 1, current_cursor_pos[2] + 1)
			if char_at_cursor_pos == " " then
				cursor_at_line_start = false
			end
		end
		self.cursor_target = movements.words(self.counter)
		current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		utility.create_highlight(current_cursor_pos[1] - 1, self.cursor_target[2], 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveWord:instructions()
	return "Move " .. self.counter .. " word(s) using 'w'."
end

return MoveWord
