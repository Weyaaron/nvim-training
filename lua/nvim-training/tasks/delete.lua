local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local Delete = {}

Delete.__index = Delete
setmetatable(Delete, { __index = Task })
Delete.metadata = { autocmd = "", desc = "", instructions = "", tags = { "deletion" } }

function Delete:new()
	local base = Task:new()
	setmetatable(base, Delete)
	base.target_text = ""
	return base
end
function Delete:deactivate()
	return self.target_text == self:read_register()
end

function Delete:delete_f(line, f_movement)
	local function _inner_update()
		self.cursor_target = utility.do_f_preparation(line, f_movement, self.target_char)
		self.target_text = utility.extract_text_from_f_coordinates(self.cursor_target)
	end

	vim.schedule_wrap(_inner_update)()
end
return Delete
