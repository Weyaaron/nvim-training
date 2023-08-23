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

local wTask = require("lua.nvim_training.tasks.movements.w_movement_task")
utility = require("lua.nvim_training.utility")
utility.create_highlight = function()
	return -1
end
utility.clear_highlight = function() end
math.random = function()
	return 5
end
TestwMovement = {}

function TestwMovement:setup()
	self.w_task = wTask:new()
	self.w_task:prepare()
end
function TestwMovement:test_setup()
	local completion_result = self.w_task:completed()
	luaunit.assertEquals(completion_result, false)
end

os.exit(luaunit.LuaUnit.run())
