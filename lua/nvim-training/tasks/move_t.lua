local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local movements = require("nvim-training.movements")
local Movet = {}

Movet.__index = Movet
setmetatable(Movet, { __index = Move })
Movet.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move using t.",
	instructions = "",
	tags = "movement, t, horizontal",
}

function Movet:new()
	local base = Move:new()
	setmetatable(base, { __index = Movet })
	base.target_char = utility.calculate_target_char()
	return base
end

function Movet:activate()
	local function _inner_update()
		local cursor_target_pos = math.random(20, 40)
		local line = utility.construct_char_line(self.target_char, cursor_target_pos + 10)
		utility.set_buffer_to_rectangle_with_line(line)

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], cursor_target_pos })

		cursor_pos = vim.api.nvim_win_get_cursor(0)
		local new_x_pos = movements.t(line, cursor_pos[2], self.target_char)
		self.cursor_target = { cursor_pos[1], new_x_pos }

		utility.construct_highlight(self.cursor_target[1], self.cursor_target[2], 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function Movet:instructions()
	return "Move next to the char '" .. self.target_char .. "' using t."
end

return Movet
