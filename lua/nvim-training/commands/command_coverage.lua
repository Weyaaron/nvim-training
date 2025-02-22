local utility = require("nvim-training.utility")

local function coverage()
	-- local MiniTest = require("mini.test")
	-- MiniTest.run()
	local task_index = require("nvim-training.task_index")
	local task_names_from_file = require("tests.test_f_tasks").task_names
	local count_table = {}
	local missing = {}
	for key, value in pairs(task_index) do
		count_table[key] = 0
		missing[key] = true
	end
	local key_table_from_mod = utility.truth_table(task_names_from_file)
	for key, task_el in pairs(task_index) do
		if key_table_from_mod[key] then
			count_table[key] = count_table[key] + 1
			missing[key] = nil
		end
	end
	-- print("coverage", vim.inspect(count_table), vim.inspect(missing))
	print("coverage", vim.inspect(missing))
end
local module = {}

function module.execute(args, opts)
	coverage()
end

function module.stop() end

function module.complete(arg_lead) end

return module
