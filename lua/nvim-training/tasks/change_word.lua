local utility = require("nvim-training.utility")
local Change = require("nvim-training.tasks.change")
local user_config = require("nvim-training.user_config")
local movements = require("nvim-training.movements")
local ChangeWord = {}

ChangeWord.__index = ChangeWord
setmetatable(ChangeWord, { __index = Change })
ChangeWord.__metadata = {
	autocmd = "InsertLeave",
	desc = "Change text using w,c.",
	instructions = "",
	tags = "change, word, horizontal, w,c",
}

function ChangeWord:new()
	local base = Change:new()
	setmetatable(base, { __index = ChangeWord })
	base.target_y_pos = 0

	base.counter = 1
	if user_config.enable_counters then
		base.counter = math.random(2, 7)
	end

	base.cursor_target = { 0, 0 }
	base.base_text = "x"
	base.new_line_text = ""
	return base
end

function ChangeWord:construct_event_data()
	return { counter = self.counter }
end

function ChangeWord:activate()
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
		current_cursor_pos = vim.api.nvim_win_get_cursor(0)

		local cursor_pos_after_movement = movements.words(self.counter)

		local line = utility.get_line(current_cursor_pos[1])
		local text_after_deletion = line:sub(0, current_cursor_pos[2])
			.. self.target_text
			.. line:sub(cursor_pos_after_movement[2], #line)

		self.cursor_target = current_cursor_pos
		self.target_line = text_after_deletion
		utility.create_highlight(current_cursor_pos[1] - 1, self.cursor_target[2], 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function ChangeWord:instructions()
	return "Change the text of " .. self.counter .. " word(s) (using w,c) into '" .. self.base_text .. "'."
end

return ChangeWord
