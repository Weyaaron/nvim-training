local SwapCase = require("nvim-training.tasks.swap_case")
local utility = require("nvim-training.utility")
local tag_index = require("nvim-training.tag_index")

local SwapCaseChar = {}
SwapCaseChar.__index = SwapCaseChar
setmetatable(SwapCaseChar, { __index = SwapCase })
SwapCaseChar.metadata = {
	autocmd = "TextChanged",
	desc = "Swap the capitalisation of the current char.",
	instructions = "Swap the capitalisation of the char at the cursor.",
	tags = utility.flatten({ tag_index.character, tag_index.case }),
}

function SwapCaseChar:new()
	local base = SwapCase:new()
	setmetatable(base, SwapCaseChar)

	return base
end

function SwapCaseChar:activate()
	local function _inner_update()
		local line = utility.construct_char_line("x", self.cursor_center_pos)
		utility.set_buffer_to_rectangle_with_line(line)

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], self.cursor_center_pos - 1 })

		self.start_index = self.cursor_center_pos
		self.end_index = self.cursor_center_pos
	end

	vim.schedule_wrap(_inner_update)()
end

return SwapCaseChar
