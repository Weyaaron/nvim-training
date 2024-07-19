local Task = require("nvim-training.task")
local YankTask = {}
YankTask.__index = YankTask

function YankTask:new()
	setmetatable(YankTask, { __index = Task })
	local base = Task:new()
	setmetatable(base, YankTask)
	base.chosen_register = "a"
	return base
end

function YankTask:deactivate(autocmd_callback_data)
	local register = self.chosen_register
	local register_content = vim.fn.getreg('"' .. register)

	-- data = vim.inspect(autocmd_callback_data)
	data = vim.inspect(self)
	data = string.gsub(data, "\n", " ")
	-- print("Reg:" .. tostring(register), "Content:" .. tostring(register_content))
	print("Reg:" .. tostring(register))
	-- print("Reg:" .. register, "Content:" .. register_content)
	-- print(self.target_text)
	-- print(self, self.target_text, self.chosen_register, register_content, "hallo", "welt", data)
	--
	local yank_success = self.target_text == register_content
	-- print("result:" .. tostring(yank_success))
	return yank_success
end

return YankTask
