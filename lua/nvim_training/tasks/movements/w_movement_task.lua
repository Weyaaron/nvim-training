-- luacheck: globals vim

local Task = require("nvim_training.task")
local utility = require("nvim_training.utility")
local MoveWordForwardTask = Task:new()

local Movements = require("lua.nvim_training.movements")
MoveWordForwardTask.base_args = { cursor_target = 0, tags = { "movement" }, autocmds = { "CursorMoved" } }

function MoveWordForwardTask:prepare()
	self:load_from_json("lorem_ipsum.buffer")

	utility.replace_main_buffer_with_str(self.initial_buffer)

	local offset= math.random(2, 5)
	local movement_result = Movements.w(self.buffer_as_list, 0,0,{offset=offset})
	self.new_buffer_coordinates = {movement_result[2], movement_result[3]}

	self.desc = "Jump " .. tostring(offset) .. " words relative to your cursor."

	self.highlight_namespace = vim.api.nvim_create_namespace("JumpWordLineNameSpace")

	vim.api.nvim_set_hl(0, "UnderScore", { underline = true })

	vim.api.nvim_buf_add_highlight(
		0,
		self.highlight_namespace,
		"UnderScore",
		self.new_buffer_coordinates[1] - 1,
		self.new_buffer_coordinates[2],
		self.new_buffer_coordinates[2] + 1
	)
end

function MoveWordForwardTask:completed()
	local current_cursor = vim.api.nvim_win_get_cursor(0)
	local x_diff = current_cursor[1] - self.new_buffer_coordinates[1]
	local y_diff = current_cursor[2] - self.new_buffer_coordinates[2]
	return x_diff == 0 and y_diff == 0
end

function MoveWordForwardTask:failed()
	return not self:completed()
end

function MoveWordForwardTask:teardown()
	if self.highlight_namespace then
		vim.api.nvim_buf_clear_namespace(0, self.highlight_namespace, 0, -1)
	end
end

return MoveWordForwardTask
