local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local internal_config = require("nvim-training.internal_config")
local movements = require("nvim-training.movements")
local user_config = require("nvim-training.user_config")
local Move_f = {}

Move_f.__index = Move_f
setmetatable(Move_f, { __index = Move })
Move_f.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move using f.",
	instructions = "Move using f.",
	tags = "movement, f, horizontal",
}

function Move_f:new()
	local base = Move:new()
	setmetatable(base, { __index = Move_f })
	base.target_y_pos = 0
	base.target_char = "0"
	return base
end

function Move_f:activate()
	local function _inner_update()
		local offset = math.random(3, 15)
		local cursor_target_pos = 20
		local target_char_index = math.random(#user_config.task_alphabet)
		self.target_char = user_config.task_alphabet:sub(target_char_index, target_char_index)
		local line = ""
		self.target_y_pos = cursor_target_pos + offset
		for i = 1, internal_config.line_length do
			local is_target_or_space = false
			if i == self.target_y_pos then
				line = line .. self.target_char
				is_target_or_space = true
			end
			if i == self.target_y_pos + 1 or i == self.target_y_pos - 1 then
				line = line .. " "
				is_target_or_space = true
			end
			if not is_target_or_space then
				line = line .. "x"
			end
		end
		utility.set_buffer_to_rectangle_with_line(line)

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], cursor_target_pos })

		self.cursor_target = { cursor_pos[1], movements.f(self.target_char) - 1 }
	end
	vim.schedule_wrap(_inner_update)()
end

function Move_f:instructions()
	return "Move to the char '" .. self.target_char .. "' using f."
end

return Move_f
