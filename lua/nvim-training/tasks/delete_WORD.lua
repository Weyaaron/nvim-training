local Delete = require("nvim-training.tasks.delete")
local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local DeleteWORD = {}
DeleteWORD.__index = DeleteWORD
setmetatable(DeleteWORD, { __index = Delete })
DeleteWORD.metadata = {
	autocmd = "TextChanged",
	desc = "Delete multiple WORDs.",
	instructions = "",
	tags = utility.flatten({ tag_index.deletion, tag_index.WORD }),
	input_template = "<target_register>d<counter>W",
}

function DeleteWORD:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteWORD })
	return base
end

function DeleteWORD:activate()
	local cursor_start = 20
	local line = ""
	local new_x_pos = -1
	while new_x_pos == -1 do
		line = utility.construct_WORDS_line()
		new_x_pos = movements.WORDS(line, 20, self.counter)
	end

	utility.set_buffer_to_rectangle_with_line(line)

	local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
	vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], cursor_start })

	current_cursor_pos = vim.api.nvim_win_get_cursor(0)
	self.cursor_target = { current_cursor_pos[1], new_x_pos }
	utility.construct_highlight(current_cursor_pos[1], self.cursor_target[2], 1)

	self.target_text = line:sub(current_cursor_pos[2] + 1, self.cursor_target[2])

	utility.construct_word_hls_forwards(self.counter)
	utility.construct_highlight(current_cursor_pos[1], self.cursor_target[2], 1)
end

function DeleteWORD:instructions()
	return "Delete "
		.. self.counter
		.. " WORDS(s)"
		.. utility.construct_register_description(self.target_register)
		.. "."
end
return DeleteWORD
