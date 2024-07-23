local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")
local user_config = require("nvim-training.user_config")

local Paste = {}
Paste.__index = Paste

setmetatable(Paste, { __index = Task })
Paste.__metadata =
	{ autocmd = "TextChanged", desc = "Paste from a given register.", instructions = "", tags = "paste, register" }

function Paste:new()
	local base = Task:new()

	setmetatable(base, { __index = Paste })
	base.reg_content = "-Content-"
	base.choosen_reg = user_config.possible_register_list[math.random(#user_config.possible_register_list)]
	return base
end

function Paste:activate()
	local function _inner_update()
		utility.set_buffer_to_rectangle_and_place_cursor_randomly()
		vim.cmd(":let @" .. self.choosen_reg .. "= '" .. self.reg_content .. "'")
	end
	vim.schedule_wrap(_inner_update)()
end

function Paste:deactivate(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_line(cursor_pos[1])
	local search = line:find(self.reg_content)
	if not search then
		return false
	end
	return search < cursor_pos[2]
end

function Paste:instructions()
	return "Paste the text from register '" .. self.choosen_reg .. "'"
end

return Paste
