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
	print(self.target_text, "--", self:read_register())
	return self.target_text == self:read_register()
end

function Delete:delete_f(line, f_movement)
	local function _inner_update()
		self.cursor_target = utility.do_f_preparation(line, f_movement, self.target_char)
		self.target_text = utility.extract_text_from_coordinates(self.cursor_target)
	end
	vim.schedule_wrap(_inner_update)()
end

function Delete:delete_word(line, word_movement)
	local function _inner_update()
		self.cursor_target = utility.do_word_preparation(line, word_movement, self.counter, 10)

		local target_with_offset = { self.cursor_target[1], self.cursor_target[2] - 2 }

		self.target_text = utility.extract_text_from_coordinates(target_with_offset)
	end
	vim.schedule_wrap(_inner_update)()
end
return Delete
