local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")
local internal_config = require("nvim-training.internal_config")
local Move_f = {}

Move_f.__index = Move_f
setmetatable(Move_f, { __index = Task })
Move_f.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move using f.",
	instructions = "Move using f.",
	tags = "movement, f, horizontal",
}

function Move_f:new()
	local base = Task:new()
	setmetatable(base, { __index = Move_f })
	base.target_y_pos = 0
	base.alphabet = "ABCDEFGabddefg,."
	--Todo: Reintrocude, maybe with difficulty setting?
	-- base.alphabet = "ABCDEFGabddefg,.}])><([{012345679"
	base.target_char = "0"
	return base
end

function Move_f:activate()
	local function _inner_update()
		local offset = math.random(3, 15)
		local cursor_target_pos = 20
		local target_char_index = math.random(#self.alphabet)
		self.target_char = self.alphabet:sub(target_char_index, target_char_index)
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
	end
	vim.schedule_wrap(_inner_update)()
end

function Move_f:deactivate(autocmd_args)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	return cursor_pos[2] == self.target_y_pos - 1
end

function Move_f:instructions()
	return "Move to the char '" .. self.target_char .. "' using f."
end

return Move_f
