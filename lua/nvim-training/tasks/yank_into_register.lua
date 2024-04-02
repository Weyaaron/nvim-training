local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local user_config = require("nvim-training.user_config")

local YankIntoRegisterTask = {}
YankIntoRegisterTask.__index = YankIntoRegisterTask

function YankIntoRegisterTask:setup()
	local base = Task:new()
	setmetatable(base, { __index = YankIntoRegisterTask })

	self.target_line = 0
	self.autocmd = "TextYankPost"
	self.possible_registers = user_config.possible_register_list
	self.choosen_register = self.possible_registers[#self.possible_register_list]
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()

		local cursor_pos = vim.api.nvim_win_get_cursor(0)

		local lines = vim.api.nvim_buf_get_lines(0, cursor_pos[1] - 1, cursor_pos[1], false)
		local line_length = #lines[1]
		self.highlight = utility.create_highlight(cursor_pos[1] - 1, cursor_pos[2], line_length)
	end
	vim.schedule_wrap(_inner_update)()
	return base
end

function YankIntoRegisterTask:teardown(autocmd_callback_data)
	utility.clear_highlight(self.highlight)
	return false
	-- return self.target_line == vim.api.nvim_win_get_cursor(0)[1]
end

function YankIntoRegisterTask:description()
	return "Use yy to copy the line the cursor is in into register " .. self.choosen_register
end

return YankIntoRegisterTask
