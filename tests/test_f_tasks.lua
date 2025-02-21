local child = MiniTest.new_child_neovim()

local task_names = {
	"Movef",
	"MoveF",
	"Movet",
	"MoveT",
	"Deletef",
	"DeleteF",
	"Deletet",
	"DeleteT",
	"Yankf",
	"YankF",
	"Yankt",
	"YankT",
}
local task_inputs = { "f", "F", "t", "T", "df", "dF", "dt", "dT", "yf", "yF", "yt", "yT" }
local tuple_params = {}

for i = 1, #task_names do
	tuple_params[i] = { task_names[i], task_inputs[i] }
end
local TestModule = MiniTest.new_set({
	hooks = {
		pre_case = function()
			-- Restart child process with custom 'init.lua' script
			child.restart({ "-u", "scripts/minimal_init.lua" })
			-- Load tested plugin
			-- child.lua([[M = require('nvim-training')]])
		end,
		-- Stop once all test cases are finished
		post_once = child.stop,
	},
	parametrize = tuple_params,
	n_retry = 3,
})

TestModule.task_names = task_names

function TestModule.test_success(task_name, task_key_desc)
	--Todo: Work on a setup that does rely on this string concatenation
	local command = "require('nvim-training').setup( {custom_collections= { UnitTest = { '"
		.. task_name
		.. "' }, "
		.. " }   })"
	child.lua(command)
	child.cmd("Training Start RandomScheduler UnitTest")
	local interface_values = child.lua_get("require('nvim-training.commands.command_start').test_interface")

	MiniTest.expect.equality(interface_values.task_data.name, task_name)
	local target_char = interface_values.task_data.target_char
	if not target_char then
		error("The task is missing key data used by the test")
	end
	local key_inputs = task_key_desc .. tostring(target_char)
	print(task_name, command, task_key_desc, key_inputs, vim.inspect(interface_values))
	child.type_keys(key_inputs)
	interface_values = child.lua_get("require('nvim-training.commands.command_start').test_interface")
	print(vim.inspect(interface_values))
	MiniTest.expect.equality(interface_values.task_results[#interface_values.task_results], true)

	MiniTest.expect.equality(#interface_values.task_results, 2)
end
return TestModule
