luaunit = require("luaunit")

local lorem_ipsum = {
	"Lorem ipsum dolor sit amet consectetur adipisici elit",
	"sed eiusmod tempor incidunt utlabore et dolore magna aliqua",
}

vim = {
	api = {
		nvim_buf_line_count = function()
			return 5
		end,
		nvim_buf_get_lines = function()
			return lorem_ipsum
		end,
		nvim_buf_set_lines = function() end,
		nvim_win_get_cursor = function()
			return { 1, 3 }
		end,
	},
	json = {
		decode = function()
			return { initial_buffer = "lorem_ipsum.buffer", new_buffer = "lorem_ipsum.buffer" }
		end,
	},
}

local utility = require("nvim_training.utility")
TestUtility = {}

function TestUtility:test_word_search_without_bound()
	local input = "abaaaa"
	local result = utility.search_for_char_in_word(input, "b")
	luaunit.assertEquals(result, 2)
end
function TestUtility:test_word_search_with_bound()
	local input_with_bound = "bab"
	local result = utility.search_for_char_in_word(input_with_bound, "b", 2)
	luaunit.assertEquals(result, 3)
end

os.exit(luaunit.LuaUnit.run())
