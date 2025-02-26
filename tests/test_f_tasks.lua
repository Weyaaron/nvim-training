local test_utils = require("nvim-training.utilities.testing")

local child = MiniTest.new_child_neovim()

local args_as_tuple = {
	{ "Movef", "f" },
	{ "MoveF", "F" },
	{ "Movet", "t" },
	{ "MoveT", "T" },
	{ "Deletef", "df" },
	{ "DeleteF", "dF" },
	{ "Deletet", "dt" },
	{ "DeleteT", "dT" },
	{ "Yankf", "yf" },
	{ "YankF", "yF" },
	{ "Yankt", "yt " },
	{ "YankT", "yT" },
}

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
	parametrize = args_as_tuple,
	n_retry = 3,
})

local task_names = {}
for i, v in pairs(args_as_tuple) do
	task_names[i] = v[1]
end
TestModule.task_names = task_names

function TestModule.test_success(task_name, task_key_desc)
	test_utils.start_task_with_args(child, task_name, {})

	local interface_values = child.lua_get("require('nvim-training.commands.command_start').test_interface")

	MiniTest.expect.equality(interface_values.task_data.name, task_name)
	local target_char = interface_values.task_data.target_char
	if not target_char then
		error("The task is missing key data used by the test")
	end
	local key_inputs = task_key_desc .. tostring(target_char)
	child.type_keys(key_inputs)
	interface_values = child.lua_get("require('nvim-training.commands.command_start').test_interface")
	MiniTest.expect.equality(interface_values.task_results[#interface_values.task_results], true)

	MiniTest.expect.equality(#interface_values.task_results, 2)
end
return TestModule
