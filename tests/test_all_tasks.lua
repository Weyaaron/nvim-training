local test_utils = require("nvim-training.utilities.testing")
local task_index = require("nvim-training.task_index")
local utility = require("nvim-training.utility")

local task_index_keys = utility.get_keys(task_index)
local names = {}
for i, v in pairs(task_index_keys) do
	names[#names + 1] = { v }
	names[#names + 1] = { v }
	names[#names + 1] = { v }
	names[#names + 1] = { v }
	names[#names + 1] = { v }
end
-- names = { { "YankInsideQuotes" } }
-- for i = 1, 10, 1 do
-- 	names[#names + 1] = names[i]
-- end

local child = MiniTest.new_child_neovim()

local TestModule = MiniTest.new_set({
	hooks = {
		pre_case = function()
			-- Restart child process with custom 'init.lua' script
			child.restart({ "-u", "scripts/minimal_init.lua" })
		end,
		post_once = child.stop,
	},
	parametrize = names,
})
TestModule.task_names = names

function TestModule.test_success(current_task_name)
	test_utils.start_task_with_args(child, current_task_name, {})
	local interface_values = test_utils.load_interface_data_from_child(child)

	MiniTest.expect.equality(interface_values.task_data.name, current_task_name)
	local key_inputs = test_utils.construct_solution_string_from_task_data(interface_values.task_data)
	child.type_keys(key_inputs)
	if key_inputs == "" then
		MiniTest.skip("Skipped because unit tests are not supported yet.")
	end
	print(key_inputs)
	MiniTest.expect.no_equality(key_inputs, "")
	interface_values = test_utils.load_interface_data_from_child(child)
	MiniTest.expect.equality(interface_values.task_results[#interface_values.task_results], true)
	print(vim.inspect(interface_values.task_results))
	-- local cp = child.lua_get("_G.cursor_target")
	-- local status = child.lua_get("_G.status")
	-- if not status[1] then
	-- 	print(vim.inspect(status))
	-- end
	-- MiniTest.add_note(vim.inspect(cp))
	MiniTest.expect.equality(#interface_values.task_results, 2)
	MiniTest.finally(function()
		if #MiniTest.current.case.exec.fails > 0 then
			MiniTest.add_note(key_inputs)
		end

		-- MiniTest.add_note("CP:", vim.inspect(cp))
	end)
end
return TestModule
