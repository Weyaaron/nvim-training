local test_task = { desc = nil, autocmds = nil }
local data = {}
local utility = require("src.utility")

function test_task.init()
	test_task.desc = "New almost empty description"
	test_task.autocmds = { "TextChanged", "CursorMoved" }
	utility.replace_main_buffer_with_str("abcededed")
end

function test_task.check()
	print("Check triggered")
end

function test_task.teardown() end

return test_task
