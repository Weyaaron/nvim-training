local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")
local current_config = require("nvim-training.current_config")

local Paste = {}
Paste.__index = Paste

function Paste:new()
	local base = Task:new()

	setmetatable(base, { __index = Paste })
	self.autocmd = "TextChanged"
	self.reg_content = "-Content-"

	self.choosen_reg = current_config.possible_register_list[math.random(#current_config.possible_register_list)]
	local options_for_choosen_mode = { "P", "p" }
	self.choosen_mode = options_for_choosen_mode[math.random(2)]

	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
		vim.cmd(":let @" .. self.choosen_reg .. "= '" .. self.reg_content .. "'")
	end
	vim.schedule_wrap(_inner_update)()
	return self
end

function Paste:teardown(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local lines = vim.api.nvim_buf_get_lines(0, cursor_pos[1] - 1, cursor_pos[1], false)
	local search = string.find(lines[1], self.reg_content)
	if not search then
		return false
	end
	return search < cursor_pos[2]
end

function Paste:description()
	return "Paste the text from register '" .. self.choosen_reg .. "' using " .. self.choosen_mode
end

return Paste
