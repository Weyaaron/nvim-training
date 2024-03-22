local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local current_config = require("nvim-training.current_config")

local YankIntoRegisterTask = Task:new({
	target_line = 0,
	autocmd = "TextYankPost",
	possible_registers = current_config.possible_register_list,
	choosen_register = "",
})

YankIntoRegisterTask.__index = YankIntoRegisterTask

function YankIntoRegisterTask:setup()
	self.choosen_register = self.possible_registers[#self.possible_register_list]
	local function _inner_update()
		local lorem_ipsum = utility.lorem_ipsum_lines()
		utility.update_buffer_respecting_header(lorem_ipsum)

		utility.update_buffer_respecting_header()

		local cursor_pos = vim.api.nvim_win_get_cursor(0)

		local lines = vim.api.nvim_buf_get_lines(0, cursor_pos[1] - 1, cursor_pos[1], false)
		local line_length = #lines[1]
		self.highlight = utility.create_highlight(cursor_pos[1] - 1, cursor_pos[2], line_length)
	end
	vim.schedule_wrap(_inner_update)()
end

function YankIntoRegisterTask:teardown(autocmd_callback_data)
	utility.clear_highlight(self.highlight)
	return false
	-- return self.target_line == vim.api.nvim_win_get_cursor(0)[1]
end

function YankIntoRegisterTask:description()
	return "Use yy to copy the current line into register " .. self.choosen_register
end

return YankIntoRegisterTask
