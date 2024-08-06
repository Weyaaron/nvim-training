local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local Yank = {}

Yank.__index = Yank
setmetatable(Yank, { __index = Task })
Yank.__metadata = { autocmd = "", desc = "", instructions = "" }

function Yank:new()
	local base = Task:new()
	setmetatable(base, Yank)

	base.chosen_register = '"'
	return base
end
function Yank:deactivate(autocmd_callback_data)
	local register_content = vim.fn.getreg(self.chosen_register)
	register_content = utility.split_str(register_content, "\n")[1]
	return self.target_text == register_content
end

return Yank
