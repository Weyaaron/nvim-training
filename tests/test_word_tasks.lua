local child = MiniTest.new_child_neovim()

local test_params_as_tuple = {
	{ "ChangeWord", "c<>wx<esc>", false },
	{ "ChangeWord", "c<>wx<esc>", true },
	{ "DeleteWord", "d<>w", false },
	{ "DeleteWORD", "d<>W", false },
	{ "DeleteWord", "d<>w", true },
	{ "DeleteWORD", "d<>W", true },
	{ "DeleteWordEnd", "d<>e", false },
	{ "DeleteWORDEnd", "d<>E", false },
	{ "DeleteWordEnd", "d<>e", true },
	{ "DeleteWORDEnd", "d<>E", true },
	{ "MoveWordEnd", "<>e", false },
	{ "MoveWordEnd", "<>e", true },
	{ "MoveWordEnd", "<>e", false },
	{ "MoveWORDEnd", "<>E", true },
	{ "MoveWordStart", "<>b", true },
	{ "MoveWORDStart", "<>B", true },
	{ "MoveWord", "<>w", false },
	{ "MoveWORD", "<>W", false },
	{ "MoveWord", "<>w", true },
	{ "MoveWORD", "<>W", true },
	{ "YankWord", "y<>w", false },
	{ "YankWORD", "y<>W", false },
	{ "YankWord", "y<>w", true },
	{ "YankWORD", "y<>W", true },
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

function TestModule.test_success(task_name, task_key_desc, test_for_register)
	--Todo: Work on a setup that does rely on this string concatenation
	-- print(vim.inspect(tuple_params))
	local command_injection_reg_test = ""
	if test_for_register then
		command_injection_reg_test = "enable_registers = true"
	end
	local command = "require('nvim-training').setup( {custom_collections= { UnitTest = { '"
		.. task_name
		.. "' },    }, "
		.. command_injection_reg_test
		.. "   })"
	child.lua(command)
	child.cmd("Training Start RandomScheduler UnitTest")
	local interface_values = child.lua_get("require('nvim-training.commands.command_start').test_interface")

	MiniTest.expect.equality(interface_values.task_data.name, task_name)
	local target_counter = interface_values.task_data.counter
	if not target_counter then
		error("The task is missing key data used by the test")
	end
	local key_inputs = task_key_desc:gsub("<>", tostring(target_counter))
	if test_for_register then
		key_inputs = '"' .. interface_values.task_data.target_register .. key_inputs
	end
	print(task_name, command, task_key_desc, key_inputs, vim.inspect(interface_values))
	child.type_keys(key_inputs)
	interface_values = child.lua_get("require('nvim-training.commands.command_start').test_interface")
	print(vim.inspect(interface_values))
	MiniTest.expect.equality(interface_values.task_results[#interface_values.task_results], true)

	MiniTest.expect.equality(#interface_values.task_results, 2)
end
return TestModule
