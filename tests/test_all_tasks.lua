local test_utils = require("nvim-training.utilities.testing")
local task_index = require("nvim-training.task_index")
local utility = require("nvim-training.utility")
local template_index = require("nvim-training.template_index")
local internal_config = require("nvim-training.internal_config")

local task_index_keys = utility.get_keys(task_index)
local names = {}
for i, v in pairs(task_index_keys) do
	names[#names + 1] = { v }
	names[#names + 1] = { v }
	names[#names + 1] = { v }
	names[#names + 1] = { v }
	names[#names + 1] = { v }
end

names = { { "ChangeWord" } }
for i = 1, 25, 1 do
	names[#names + 1] = names[i]
end

local base_template = utility.load_line_template(template_index.LoremIpsum)
base_template = utility.split_str(base_template, "\n")[1]
local words = utility.split_str(base_template, " ")

local words_pairwise = {}
for i, v in pairs(words) do
	for ii, vv in pairs(words) do
		words_pairwise[#words_pairwise + 1] = { v, vv }
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
	parametrize = words_pairwise,
})
TestModule.task_names = names

local random_seed = 124134
local broken_seed = 124143

local rd_diff = 0
function TestModule.test_success(w1, w2)
	local word_pair = { w1, w2 }

	local current_task_name = "ChangeWord"
	rd_diff = rd_diff + 1
	local cur_rand = random_seed + rd_diff
	-- cur_rand = broken_seed
	math.randomseed(broken_seed)
	_G.status = {}
	_G.status.seed = cur_rand
	test_utils.start_task_with_args(child, current_task_name, {})
	local interface_values = test_utils.load_interface_data_from_child(child)
	-- child.lua("_G.status = {}; _G.status.seed =" .. cur_rand)
	-- child.lua("_G.status = {}; _G.status.word_pair= {" .. w1 .. "," .. w2 .. "}")
	-- child._G = {}
	-- child._G.status = {}
	-- child._G.status.seed = cur_rand
	MiniTest.expect.equality(interface_values.task_data.name, current_task_name)
	local actual_lines =
		child.api.nvim_buf_get_lines(0, internal_config.header_length, internal_config.header_length + 5, true)
	local key_inputs = test_utils.construct_solution_string_from_task_data(interface_values.task_data)
	child.type_keys(key_inputs)
	if key_inputs == "" then
		MiniTest.skip("Skipped because unit tests are not supported yet.")
	end
	-- print(key_inputs)
	MiniTest.expect.no_equality(key_inputs, "")
	interface_values = test_utils.load_interface_data_from_child(child)
	local status = child.lua_get("_G.status")
	local last_res = interface_values.task_results[#interface_values.task_results]
	local deq = vim.deep_equal(last_res, true)
	-- print(last_res, deq, type(last_res), vim.inspect(status))
	status.actual_line = actual_lines[4]
	print(last_res, vim.inspect(status), cur_rand)
	MiniTest.expect.equality(last_res, true)
	-- print(vim.inspect(interface_values.task_results))
	-- local cp = child.lua_get("_G.cursor_target")
	-- if not status["res"] then
	-- print(vim.inspect(status), vim.inspect(interface_values), last_res, vim.deep_equal(last_res, true))
	-- print(vim.inspect(interface_values))
	-- end
	-- MiniTest.add_note(vim.inspect(cp))
	MiniTest.expect.equality(#interface_values.task_results, 2)
	MiniTest.finally(function()
		if #MiniTest.current.case.exec.fails > 0 then
			MiniTest.add_note(key_inputs)
			-- print(last_res, deq, type(last_res), vim.inspect(status))
		end

		-- MiniTest.add_note("CP:", vim.inspect(cp))
	end)
end
return TestModule
