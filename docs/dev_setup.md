# A very basic setup for running this plugin for development

I have automated the setup to cut down on startup/development time by
placing these lines in my init.lua:

```lua
local file = vim.fn.expand("%")

if file == "dump.txt" then
	vim.cmd("so /home/aaron/Code/Lua/nvim-training/dev_setup.lua")
end
```
This causes the file to be loaded when I enter the file 'dump.txt'.
Furthermore, this is the content of dev_setup.lua:

```lua
vim.cmd("ASToggle")
local training = require("nvim-training")
training.setup({
	task_list = { "MoveStartOfFile", "MoveEndOfLine", "MoveStartOfLine", "Increment" },
	-- task_list = { "YankWord" },
	task_scheduler = "RandomScheduler",
	task_scheduler_kwargs = {},
	-- task_scheduler_kwargs = { hallo = 5 },
})
vim.cmd("Training")
```
This causes the auto-start of the plugin on startup of neovim.
It should run on your setup with minimal adjustments. 

This is just my current toolchain, suggestions for improvement
are appreciated.
