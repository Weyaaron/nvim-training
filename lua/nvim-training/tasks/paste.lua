local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")
local user_config = require("nvim-training.user_config")

local paste = {}
paste.__index = paste
setmetatable(paste, { __index = Task })
paste.metadata = {
	autocmd = "TextChanged",
	desc = "Paste from a given register.",
	instructions = "",
	tags = { "paste", "register" },
}

function paste:new()
	local base = Task:new()

	setmetatable(base, { __index = paste })
	base.reg_content = "-Content of next Line-\r"
	return base
end

function paste:activate()
	local function _inner_update()
		local random_line = utility.load_random_line()
		utility.set_buffer_to_rectangle_with_line(random_line)

		vim.fn.setreg(self.target_register, self.reg_content)
	end
	vim.schedule_wrap(_inner_update)()
end

function paste:deactivate()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_line(cursor_pos[1])
	local next_line = utility.get_line(cursor_pos[1] + 1)
	return #next_line < #line
end

function paste:instructions()
	return "Paste the text from register '" .. self.target_register .. "' into the next line."
end

return paste
