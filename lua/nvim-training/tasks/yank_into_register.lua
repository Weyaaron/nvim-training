local utility = require("nvim-training.utility")
local user_config = require("nvim-training.user_config")
local YankTask = require("nvim-training.tasks.yank")

local YankIntoRegister = YankTask:new()
YankIntoRegister.__index = YankIntoRegister

function YankIntoRegister:new()
	local base = YankTask:new()
	setmetatable(base, { __index = YankIntoRegister })

	-- self.target_line = 0
	self.autocmd = "TextYankPost"
	self.possible_registers = user_config.possible_register_list
	self.chosen_register = self.possible_registers[#self.possible_registers]
	
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()

		local cursor_pos = vim.api.nvim_win_get_cursor(0)

		local lines = vim.api.nvim_buf_get_lines(0, cursor_pos[1] - 1, cursor_pos[1], false)
		local line_length = #lines[1]
		self.highlight = utility.create_highlight(cursor_pos[1] - 1, cursor_pos[2], line_length)
		
		self.target_text = lines[1] .. "\n"
	end
	vim.schedule_wrap(_inner_update)()
	return base
end

function YankIntoRegister:description()
	return "Copy the line the cursor is in into register " .. self.chosen_register
end

return YankIntoRegister
