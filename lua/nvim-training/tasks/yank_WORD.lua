local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")
local Yank = require("nvim-training.tasks.yank")
local user_config = require("nvim-training.user_config")
local internal_config = require("nvim-training.internal_config")
local YankWORD = {}

YankWORD.__index = YankWORD
setmetatable(YankWORD, { __index = Yank })
YankWORD.__metadata = {
	autocmd = "TextYankPost",
	desc = "Yank using w.",
	instructions = "",
	tags = "yank, word, horizontal, w, counter",
}

function YankWORD:new()
	local base = Yank:new()
	setmetatable(base, { __index = YankWORD })
	base.target_y_pos = 0

	base.counter = 1
	if user_config.enable_counters then
		base.counter = math.random(2, 5)
	end

	base.cursor_target = { 0, 0 }
	return base
end

function YankWORD:activate()
	local function _inner_update()
		local word_line = utility.construct_WORDS_line()
		word_line = word_line:sub(0, internal_config.line_length)
		utility.set_buffer_to_rectangle_with_line(word_line)

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], math.random(1, 10) })

		self.cursor_target = movements.WORDS(self.counter)
		current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		utility.create_highlight(current_cursor_pos[1] - 1, self.cursor_target[2], 1)

		local line = utility.get_line(current_cursor_pos[1])
		self.target_text = line:sub(current_cursor_pos[2] + 1, self.cursor_target[2])
	end
	vim.schedule_wrap(_inner_update)()
end

function YankWORD:instructions()
	return "Yank " .. self.counter .. " word(s) using 'w'."
end

return YankWORD
