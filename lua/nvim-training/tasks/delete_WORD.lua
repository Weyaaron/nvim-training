local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local movements = require("nvim-training.movements")

local DeleteWORD = {}
DeleteWORD.__index = DeleteWORD
setmetatable(DeleteWORD, { __index = Delete })
DeleteWORD.__metadata = {
	autocmd = "TextChanged",
	desc = "Delete using 'W'.",
	instructions = "",
	tags = "deletion, movement, word",
}

function DeleteWORD:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteWORD })
	base.target_text = ""

	return base
end

function DeleteWORD:activate()
	local function _inner_update()
		local word_line = utility.construct_WORDS_line()
		utility.set_buffer_to_rectangle_with_line(word_line)

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], 20 })

		self.cursor_target = movements.WORDS(self.counter)
		current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		utility.construct_highlight(current_cursor_pos[1], self.cursor_target[2], 1)

		self.target_text = word_line:sub(current_cursor_pos[2] + 1, self.cursor_target[2])

		utility.construct_WORD_hls_forwards(self.counter)
		utility.construct_highlight(current_cursor_pos[1], self.cursor_target[2], 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function DeleteWORD:instructions()
	return "Delete " .. self.counter .. " word(s) using 'W'."
end
return DeleteWORD
