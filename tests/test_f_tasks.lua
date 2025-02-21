local child = MiniTest.new_child_neovim()

local task_names = { "Movef", "MoveF", "Deletef" }
local task_inputs = { "f", "F", "f" }
local tuple_params = {}

for i = 0, #task_names do
	tuple_params[i] = { task_names[i], task_inputs[i] }
	print(vim.inspect(tuple_params))
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
})

function TestModule.test_success(task_name, task_key_desc)
	child.lua(
		"require('nvim-training').setup( {curent_custom_collection = { UnitTest = { '" .. task_name .. "' } }   })"
	)
	child.cmd("Training Start RandomScheduler UnitTest")
	local interface_values = child.lua_get("require('nvim-training.commands.command_start').test_interface")

	local target_char = interface_values.task_data.target_char
	if not target_char then
		error("The task is missing key data used by the test")
	end
	local key_inputs = task_key_desc .. tostring(target_char)
	print(task_name, task_key_desc, key_inputs)
	child.type_keys(key_inputs)
	local interface_values_after_task_completion =
		child.lua_get("require('nvim-training.commands.command_start').test_interface")

	MiniTest.expect.equality(
		interface_values_after_task_completion.task_results[#interface_values_after_task_completion.task_results],
		true
	)

	MiniTest.expect.equality(#interface_values_after_task_completion.task_results, 1)
end
return TestModule
