local task_index = require("nvim-training.task_index")
local user_config = require("nvim-training.user_config")
local module = {}

local suffix = "Please check for spelling, and ensure you are using the right version of the plugin."

module.check = function()
	vim.health.start("Tasks")
	vim.health.ok("Currently work in progress.")
end

return module
