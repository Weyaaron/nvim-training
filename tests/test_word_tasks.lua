local test_utils = require("nvim-training.utilities.testing")

local child = MiniTest.new_child_neovim()

local test_params_as_tuple = {
	{ "ChangeWord", "c<>wx<esc>" },
	{ "DeleteWord", "d<>w" },
	{ "DeleteWORD", "d<>W" },
	{ "DeleteWordEnd", "d<>e" },
	{ "DeleteWORDEnd", "d<>E" },
	{ "MoveWordEnd", "<>e" },
	{ "MoveWORDEnd", "<>E" },
	{ "MoveWordStart", "<>b" },
	{ "MoveWORDStart", "<>B" },
	{ "MoveWord", "<>w" },
	{ "MoveWORD", "<>W" },
	{ "YankWord", "y<>w" },
	{ "YankWORD", "y<>W" },
}
local task_names = {}
for i, v in pairs(test_params_as_tuple) do
	task_names[#task_names + 1] = v[1]
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
	parametrize = test_params_as_tuple,
	n_retry = 3,
})

TestModule.task_names = task_names

function TestModule.test_basic_success(task_name, task_key_desc)
	test_utils.start_task_with_args(child, task_name, {})
	local interface_values = child.lua_get("require('nvim-training.commands.command_start').test_interface")

	MiniTest.expect.equality(interface_values.task_data.name, task_name)
	local target_counter = interface_values.task_data.counter
	if not target_counter then
		error("The task is missing key data used by the test")
	end
	local key_inputs = task_key_desc:gsub("<>", tostring(target_counter))
	child.type_keys(key_inputs)
	interface_values = child.lua_get("require('nvim-training.commands.command_start').test_interface")
	MiniTest.expect.equality(interface_values.task_results[#interface_values.task_results], true)

	MiniTest.expect.equality(#interface_values.task_results, 2)
end

function TestModule.test_register_success(task_name, task_key_desc)
	test_utils.start_task_with_args(child, task_name, { "enable_registers = true" })

	local interface_values = child.lua_get("require('nvim-training.commands.command_start').test_interface")

	MiniTest.expect.equality(interface_values.task_data.name, task_name)
	local target_counter = interface_values.task_data.counter
	if not target_counter then
		error("The task is missing key data used by the test")
	end
	local key_inputs = '"'
		.. interface_values.task_data.target_register
		.. task_key_desc:gsub("<>", tostring(target_counter))
	child.type_keys(key_inputs)
	interface_values = child.lua_get("require('nvim-training.commands.command_start').test_interface")
	MiniTest.expect.equality(interface_values.task_results[#interface_values.task_results], true)

	MiniTest.expect.equality(#interface_values.task_results, 2)
end

return TestModule
