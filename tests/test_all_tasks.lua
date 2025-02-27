local test_utils = require("nvim-training.utilities.testing")
local task_index = require("nvim-training.task_index")
local utility = require("nvim-training.utility")

local task_index_keys = utility.get_keys(task_index)
local names = {}
for i, v in pairs(task_index_keys) do
	local tags = task_index[v].metadata.tags
	local truthy_tags = utility.truth_table(tags)
	if truthy_tags["word"] or truthy_tags["WORD"] then
		names[#names + 1] = { v }
	end
end

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
	MiniTest.expect.no_equality(key_inputs, "")
	interface_values = test_utils.load_interface_data_from_child(child)
	MiniTest.expect.equality(interface_values.task_results[#interface_values.task_results], true)
	MiniTest.expect.equality(#interface_values.task_results, 2)
end
return TestModule
