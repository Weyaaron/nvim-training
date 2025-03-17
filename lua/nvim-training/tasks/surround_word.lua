local utility = require("nvim-training.utility")
local Change = require("nvim-training.tasks.change")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local SurroundWord = {}
SurroundWord.__index = SurroundWord
setmetatable(SurroundWord, { __index = Change })
SurroundWord.metadata = {
	autocmd = "TextChanged",
	desc = "Surround a word.",
	instructions = "",
	tags = utility.flatten({ tag_index.surround, tag_index.word }),
	-- input_template = "c<counter>wx<esc>",
}

function SurroundWord:new()
	local base = Change:new()
	setmetatable(base, { __index = SurroundWord })
	base.line_text_after_change = ""
	return base
end

function SurroundWord:activate()
	local function _inner_update()
		local new_line = utility.construct_words_line()
		utility.set_buffer_to_rectangle_with_line(new_line)

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], 10 })
		current_cursor_pos = vim.api.nvim_win_get_cursor(0)

		local cursor_pos_after_movement = movements.words(new_line, current_cursor_pos[2], self.counter)
                -- w1 w3 w4
		-- local line = utility.get_line(current_cursor_pos[1])
		-- self.line_text_after_change = line:sub(0, current_cursor_pos[2])
		-- 	.. self.text_to_be_inserted
		-- 	.. line:sub(cursor_pos_after_movement, #line)
		--
		-- self.cursor_target = current_cursor_pos

		utility.construct_WORD_hls_forwards(self.counter)
		utility.construct_highlight(current_cursor_pos[1], cursor_pos_after_movement, 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function SurroundWord:instructions()
	return "Surround " .. self.counter .. " words(s) with'" .. self.text_to_be_inserted .. "'."
end

return SurroundWord
