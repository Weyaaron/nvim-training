local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local internal_config = require("nvim-training.internal_config")
local movements = require("nvim-training.movements")
local user_config = require("nvim-training.user_config")

local Deletef = {}
Deletef.__index = Deletef
setmetatable(Deletef, { __index = Delete })
Deletef.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move using f.",
	instructions = "Move using f.",
	tags = "movement, f, horizontal",
}

function Deletef:new()
	local base = Delete:new()
	setmetatable(base, { __index = Deletef })
	self.target_char = utility.calculate_target_char()
	return base
end

function Deletef:activate()
	local function _inner_update()
		local target_index = math.random(20, 40)
		local line = utility.construct_char_line(self.target_char, target_index + 10)
		utility.set_buffer_to_rectangle_with_line(line)

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], target_index })
		cursor_pos = vim.api.nvim_win_get_cursor(0)
		self.cursor_target = { cursor_pos[1], movements.f(line, cursor_pos[2], self.target_char) }

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		self.target_text = line:sub(target_index + 1, self.cursor_target[2] + 1)
		utility.construct_highlight(
			self.cursor_target[1],
			cursor_pos[2],
			math.abs(self.cursor_target[2] - cursor_pos[2]) + 1
		)
	end
	vim.schedule_wrap(_inner_update)()
end

function Deletef:instructions()
	return "Delete to the char '" .. self.target_char .. "' using f."
end

return Deletef
