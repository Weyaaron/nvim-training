local test_utils = require("nvim-training.utilities.testing")
local task_index = require("nvim-training.task_index")
local utility = require("nvim-training.utility")

local task_index_keys = utility.get_keys(task_index)
local names = {}
for i, v in pairs(task_index_keys) do
	local template_str = task_index[v].metadata.input_template
	if template_str then
		names[#names + 1] = { v }
	end
end

local names_as_pairs = {}
for i, v in pairs(names) do
	for ii, vv in pairs(names) do
		names_as_pairs[#names_as_pairs + 1] = { v, vv }
	end
end

local _tmp_names = {}
for i = 1, 3 do
	_tmp_names[i] = names_as_pairs[i]
end

-- names_as_pairs = _tmp_names

--This is currently not implemented yet ..

-- names_as_pairs = { { "a", "b" }, { "c", "d" } }
print(vim.inspect(names_as_pairs))

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
	parametrize = names_as_pairs,
	-- n_retry = 3,
})

TestModule.task_names = names

function TestModule.test_success(first_task_name, second_task_name)
	print(vim.inspect(first_task_name), vim.inspect(second_task_name))
	test_utils.start_multiple_tasks(child, { first_task_name[1], second_task_name[1] }, {})
	local interface_values = test_utils.load_interface_data_from_child(child)

	-- MiniTest.expect.equality(interface_values.task_data.name, first_task_name)
	local key_inputs = test_utils.construct_solution_string_from_task_data(interface_values.task_data)
	if key_inputs == "" then
		MiniTest.skip("Skipped because first entry in pair does not support unit tests.")
	end

	interface_values = test_utils.load_interface_data_from_child(child)

	MiniTest.expect.equality(interface_values.task_results[#interface_values.task_results], true)

	-- MiniTest.expect.equality(#interface_values.task_results, 2)

	key_inputs = test_utils.construct_solution_string_from_task_data(interface_values.task_data)
	-- MiniTest.expect.equality(interface_values.task_data.name, first_task_name)
	if key_inputs == "" then
		MiniTest.skip("Skipped because first entry in pair does not support unit tests.")
	end

	child.type_keys(key_inputs)
	MiniTest.expect.no_equality(key_inputs, "")
	interface_values = test_utils.load_interface_data_from_child(child)
	MiniTest.expect.equality(interface_values.task_results[#interface_values.task_results], true)

	MiniTest.expect.equality(#interface_values.task_results, 2)
end
return TestModule
