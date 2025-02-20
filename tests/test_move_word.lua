local child = MiniTest.new_child_neovim()

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
	parametrize = { { "MoveWord", "DeleteWord" }, { "w", "d" } },
})

function TestModule.test_success(task_name, task_key_desc)
	child.lua(
		"require('nvim-training').setup( {curent_custom_collection = { UnitTest = { '" .. task_name .. "' } }   })"
	)
	child.cmd("Training Start RandomScheduler UnitTest")
	local interface_values = child.lua_get("require('nvim-training.commands.command_start').test_interface")

	local counter_from_task = interface_values.current_task.counter
	child.type_keys(tostring(counter_from_task) .. task_key_desc)
	local interface_values_after_task_completion =
		child.lua_get("require('nvim-training.commands.command_start').test_interface")

	MiniTest.expect.equality(
		interface_values_after_task_completion.task_results[#interface_values_after_task_completion.task_results],
		true
	)

	MiniTest.expect.equality(#interface_values_after_task_completion.task_results, 1)
end
return TestModule
