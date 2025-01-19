local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local tag_index = require("nvim-training.tag_index")

local SwapCase = {}
SwapCase.__index = SwapCase
setmetatable(SwapCase, { __index = Task })
SwapCase.metadata =
	{ autocmd = "", desc = "", instructions = "", tags = utility.flatten({ tag_index.case, tag_index.character }) }

function SwapCase:new()
	local base = Task:new()
	setmetatable(base, SwapCase)
	base.start_index = 0
	base.end_index = 10
	--We assume that the result is uppercase
	return base
end
function SwapCase:deactivate()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_line(cursor_pos[1])
	local line_piece = line:sub(self.start_index, self.end_index)
	local is_upper = true

	print("lp", line_piece, is_upper)
	for i = 1, #line_piece do
		local char_is_lower = string.lower(line_piece:sub(i, i)) == line_piece[i]
		is_upper = is_upper and not char_is_lower
	end

	print("lp", line_piece, is_upper)
	return is_upper
end

function SwapCase:swap_case_with_word_movement(line, movement)
	local function _inner_update()
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		utility.set_buffer_to_rectangle_with_line(line)
		local target_pos = movement(line, cursor_pos[2], self.counter)

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], self.cursor_center_pos - 1 })

		self.start_index = cursor_pos[2]
		self.end_index = target_pos
	end

	vim.schedule_wrap(_inner_update)()
end

return SwapCase
