local utility = require("nvim-training.utility")
local Change = require("nvim-training.tasks.change")
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

	base.base_text = "x"
	base.new_line_text = ""
	return base
end

function ChangeWord:construct_event_data()
	return { counter = self.counter }
end

function ChangeWord:activate()
	local function _inner_update()
		local new_line = utility.construct_words_line()
		utility.set_buffer_to_rectangle_with_line(new_line)

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], 10 })
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
