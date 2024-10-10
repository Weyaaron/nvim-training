local Move = require("nvim-training.tasks.move")
local utility = require("nvim-training.utility")
local internal_config = require("nvim-training.internal_config")

local MoveRandom = {}
MoveRandom.__index = MoveRandom
setmetatable(MoveRandom, { __index = Move })
MoveRandom.metadata = {
	autocmd = "CursorMoved",
	desc = "Move to the random target.",
	instructions = "Move to the random highlight.",
	notes = "This task assumes the existence of a plugin that provides such a motion.",
	tags = utility.flatten({ Move.metadata.tags, "plugin,  diagonal" }),
}
setmetatable(MoveRandom, { __index = Move })

function MoveRandom:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveRandom })
	base.cursor_target =
		{ math.random(internal_config.header_length, internal_config.header_length + 5), math.random(5, 25) }
	return base
end
function MoveRandom:activate()
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()

		utility.construct_highlight(self.cursor_target[1], 0, self.cursor_target[2])
		local line = utility.get_line(self.cursor_target[1])
		utility.construct_highlight(self.cursor_target[1], self.cursor_target[2] + 1, #line - 1)
	end
	vim.schedule_wrap(_inner_update)()
end

return MoveRandom
