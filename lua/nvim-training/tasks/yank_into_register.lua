local utility = require("nvim-training.utility")
local user_config = require("nvim-training.user_config")
local YankTask = require("nvim-training.tasks.yank")

local YankIntoRegister = {}
YankIntoRegister.__index = YankIntoRegister

function YankIntoRegister:new()
	setmetatable(YankIntoRegister, { __index = YankTask })
	local base = YankTask:new()
	setmetatable(base, YankIntoRegister)

	base.autocmd = "TextYankPost"
	base.possible_registers = user_config.possible_register_list
	base.chosen_register = base.possible_registers[math.random(#base.possible_registers)]

	vim.fn.setreg('"' .. base.chosen_register, "")
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()

		local cursor_pos = vim.api.nvim_win_get_cursor(0)

		local lines = vim.api.nvim_buf_get_lines(0, cursor_pos[1] - 1, cursor_pos[1], false)
		local line_length = #lines[1]
		utility.create_highlight(cursor_pos[1] - 1, 0, line_length)

		base.target_text = lines[1] .. "\n"
	end
	vim.schedule_wrap(_inner_update)()
	base.target_text = "Target"

	return base
end

function YankIntoRegister:description()
	return "Copy the line the cursor is in into register " .. self.chosen_register
end

return YankIntoRegister
