local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")

local Yank = {}
Yank.__index = Yank
setmetatable(Yank, { __index = Task })
Yank.metadata = { autocmd = "", desc = "", instructions = "", tags = { "yank", "register" } }

function Yank:new()
	local base = Task:new()
	setmetatable(base, Yank)
	return base
end
function Yank:deactivate()
	local reg = self:read_register()
	print(self.target_text, #self.target_text, reg, #reg)
	return self.target_text == self:read_register()
end

function Yank:yank_f(line, f_movement)
	local function _inner_update()
		self.cursor_target = utility.do_f_preparation(line, f_movement, self.target_char)
		self.target_text = utility.extract_text_from_coordinates(self.cursor_target)
	end

	vim.schedule_wrap(_inner_update)()
end

return Yank
