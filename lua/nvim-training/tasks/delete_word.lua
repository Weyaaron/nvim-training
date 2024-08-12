local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local movements = require("nvim-training.movements")
local user_config = require("nvim-training.user_config")

local DeleteWord = {}

DeleteWord.__index = DeleteWord
setmetatable(DeleteWord, { __index = Delete })
DeleteWord.__metadata = {
	autocmd = "TextChanged",
	desc = "Delete using 'w'.",
	instructions = "",
	tags = "deletion, movement,word",
}

function DeleteWord:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteWord })
	base.target_text = ""

	base.counter = 1
	if user_config.enable_counters then
		base.counter = math.random(2, 7)
	end
	return base
end

function DeleteWord:activate()
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

		local line = utility.get_line(current_cursor_pos[1])
		self.target_text = line:sub(current_cursor_pos[2] + 1, self.cursor_target[2])
	end
	vim.schedule_wrap(_inner_update)()
end

function DeleteWord:instructions()
	return "Delete " .. self.counter .. " word(s) using 'w'."
end
return DeleteWord
