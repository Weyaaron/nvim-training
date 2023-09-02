-- luacheck: globals vim

local TestTask = require("lua.nvim_training.task"):new()
TestTask.base_args = {
	tags = { "movement", "test", "absolute" },
	autocmds = { "CursorMoved" },
	help = " (Tip: For testing purposes only!)",
	min_level = 1,
	description = "Test only.",
}

local results = {}
local result_counter = 1
for i = 1, 100 do
	table.insert(results, true)
	--table.insert(results, false)
end

function TestTask:setup()
	self.instruction = "Test Task"
end
function TestTask:completed()
	global_log.info("Completed test task with " .. tostring(result_counter) .. " " .. tostring(results[result_counter]))
	return results[result_counter]
end

function TestTask:failed()
	return not results[result_counter]
end

function TestTask:teardown()
	result_counter = result_counter + 1
end

return TestTask
