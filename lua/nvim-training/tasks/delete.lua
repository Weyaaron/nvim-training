local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local Delete = {}

Delete.__index = Delete
setmetatable(Delete, { __index = Task })
Delete.__metadata = { autocmd = "", desc = "", instructions = "" }

function Delete:new()
	local base = Task:new()
	setmetatable(base, Delete)
	base.target_text = ""
	return base
end
function Delete:deactivate()
	local register_content = vim.fn.getreg('"')
	register_content = utility.split_str(register_content, "\n")[1]
	return self.target_text == register_content
end

return Delete
