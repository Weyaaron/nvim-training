local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")
local user_config = require("nvim-training.user_config")

local Paste = {}
Paste.__index = Paste
setmetatable(Paste, { __index = Task })
Paste.metadata = {
	autocmd = "TextChanged",
	desc = "Paste from a given register.",
	instructions = "",
	tags = { "Paste", "register" },
	input_template = "<target_register>P",
}

function Paste:new()
	local base = Task:new()

	setmetatable(base, { __index = Paste })
	base.reg_content = "-Content of previous Line-\r"
	return base
end

function Paste:activate()
	local function _inner_update()
		local random_line = utility.load_random_line()
		utility.set_buffer_to_rectangle_with_line(random_line)
		vim.cmd(":let @" .. self.target_register .. "= '" .. self.reg_content .. "'")
	end
	vim.schedule_wrap(_inner_update)()
end

function Paste:deactivate()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_line(cursor_pos[1])
	local prev_line = utility.get_line(cursor_pos[1] - 1)
	return #prev_line < #line
end

function Paste:instructions()
	return "Paste the text from register '" .. self.target_register .. "' into the line above the current."
end

return Paste
