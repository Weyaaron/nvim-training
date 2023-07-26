if vim.g.loaded_training == 1 then
	print("Not loaded")
	return
end
vim.g.loaded_training = 1

local entry = require('lua.nvim_training.entry')
vim.api.nvim_create_user_command("Training", entry.setup, {})

