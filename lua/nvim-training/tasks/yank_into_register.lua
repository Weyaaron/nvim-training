local utility = require("nvim-training.utility")
local user_config = require("nvim-training.user_config")
local Yank = require("nvim-training.tasks.yank")

local YankIntoRegister = {}
YankIntoRegister.__index = YankIntoRegister

YankIntoRegister.__metadata = {
	autocmd = "TextYankPost",
	desc = "Yank a line into a register.",
	instructions = "",
	tags = "register, copy, line, vertical",
}

setmetatable(YankIntoRegister, { __index = Yank })
function YankIntoRegister:new()
	local base = Yank:new()
	setmetatable(base, YankIntoRegister)
	base.chosen_register = user_config.possible_register_list[math.random(#user_config.possible_register_list)]
	base.chosen_register = "a"
	return base
end
function YankIntoRegister:activate()
	vim.fn.setreg(self.chosen_register, "")
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()

		local cursor_pos = vim.api.nvim_win_get_cursor(0)

		local current_line = vim.api.nvim_buf_get_lines(0, cursor_pos[1] - 1, cursor_pos[1], false)[1]
		local line_length = #current_line
		utility.construct_highlight(cursor_pos[1], 0, line_length)
		self.target_text = current_line
	end
	vim.schedule_wrap(_inner_update)()
end

function YankIntoRegister:instructions()
	return "Copy the current line into register " .. self.chosen_register
end

return YankIntoRegister
