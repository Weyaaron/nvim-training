local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local internal_config = require("nvim-training.internal_config")

local MoveRandom = {}
MoveRandom.__index = MoveRandom

MoveRandom.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move to the random target.",
	instructions = "Move to the random highlight.",
	notes = "This task assumes the existence of a plugin that provides such a motion.",
	tags = "plugin, movement, diagonal",
}
setmetatable(MoveRandom, { __index = Task })
function MoveRandom:new()
	local base = Task:new()
	setmetatable(base, { __index = MoveRandom })

	base.target_x = math.random(internal_config.header_length, internal_config.header_length + 5)
	base.target_y = math.random(5, 25)
	return base
end
function MoveRandom:activate()
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
		utility.create_highlight(self.target_x, self.target_y, 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveRandom:deactivate(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	return cursor_pos[1] == self.target_x + 1 and cursor_pos[2] == self.target_y
end

return MoveRandom
