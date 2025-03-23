local Yank = require("nvim-training.tasks.yank")
local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")
local internal_config = require("nvim-training.internal_config")
local tag_index = require("nvim-training.tag_index")

local YankWordEnd = {}
YankWordEnd.__index = YankWordEnd
setmetatable(YankWordEnd, { __index = Yank })
YankWordEnd.metadata = {
	autocmd = "TextYankPost",
	desc = "Yank to the end of words.",
	instructions = "",
	tags = utility.flatten({ tag_index.yank, tag_index.word_end }),
	input_template = "<target_register>y<counter>e",
}

function YankWordEnd:new()
	local base = Yank:new()
	setmetatable(base, { __index = YankWordEnd })
	return base
end

function YankWordEnd:activate()
	local function _inner_update()
		local word_line = utility.construct_words_line()
		word_line = word_line:sub(0, internal_config.line_length)
		utility.set_buffer_to_rectangle_with_line(word_line)

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], math.random(1, 10) })

		current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		self.cursor_target =
			{ current_cursor_pos[1], movements.word_end(word_line, current_cursor_pos[2], self.counter) }
		current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		utility.construct_highlight(current_cursor_pos[1], self.cursor_target[2], 1)

		local line = utility.get_line(current_cursor_pos[1])
		self.target_text = line:sub(current_cursor_pos[2] + 1, self.cursor_target[2])

		utility.construct_word_hls_forwards(self.counter)
		utility.construct_highlight(current_cursor_pos[1], self.cursor_target[2], 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function YankWordEnd:instructions()
	return "Yank to"
		.. self.counter
		.. " end of word(s)"
		.. utility.construct_register_description(self.target_register)
		.. "."
end

return YankWordEnd
