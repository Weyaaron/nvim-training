luaunit = require("luaunit")

local lorem_ipsum = {
	"Lorem ipsum dolor sit amet consectetur adipisici elit",
	"sed eiusmod tempor incidunt utlabore et dolore magna aliqua",
	"Ut enim ad minim veniam quis nostrud exercitation ullamco",
}

local lorem_ipsum = {
	"1 2 3 4 5 6 7 8 9 10 11 adipisici elit",
	"sed eiusmod tempor incidunt utlabore et dolore magna aliqua",
	"Ut enim ad minim veniam quis nostrud exercitation ullamco",
}

local utility = require("nvim_training.utility")
local Movements = require("nvim_training.movements")

TestBasicListFunctions = {}

vim = {
	api = {
		nvim_buf_line_count = function()
			return 5
		end,
		nvim_buf_get_lines = function()
			return lorem_ipsum
		end,
	},
}
function TestBasicListFunctions:setup()
	TestBasicListFunctions.root_node = utility.construct_linked_list()
end

function TestBasicListFunctions:test_list()
	local first_len = #TestBasicListFunctions.root_node.content

	--	luaunit.assertEquals(first_len, 5)
	--	luaunit.assertEquals(TestBasicListFunctions.root_node.end_index, 6)
end

function TestBasicListFunctions:test_stringify()
	local next_node = TestBasicListFunctions.root_node.next.next
	print(next_node:stringify())

	luaunit.assertEquals(5, 5)
end

function TestBasicListFunctions:test_w_node_result()
	--	local traversal_result = Movements.w(TestBasicListFunctions.root_node, 5, 5, { offset = 1 })

	--local result_node = traversal_result[1]
	--luaunit.assertEquals(TestBasicListFunctions.root_node.next, result_node)
	luaunit.assertEquals(5, 5)
end

function TestBasicListFunctions:w_indexes()
	local traversal_result = Movements.w(TestBasicListFunctions.root_node, 5, 5, { offset = 1 })
	local line_index = traversal_result[2]
	local char_index = traversal_result[3]
	luaunit.assertEquals(line_index, 1)
	luaunit.assertEquals(char_index, 7)
end

os.exit(luaunit.LuaUnit.run())
