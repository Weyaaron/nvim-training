local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local current_config = require("nvim-training.current_config")

local MoveRandomXY = {}
MoveRandomXY.__index = MoveRandomXY

function MoveRandomXY:new()
	local base = Task:new()
	setmetatable(base, { __index = MoveRandomXY })

	self.target_x = math.random(current_config.header_length, current_config.header_length + 5)
	self.target_y = math.random(5, 25)
	self.autocmd = "CursorMoved"
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
		self.highlight = utility.create_highlight(self.target_x, self.target_y, 1)
	end
	vim.schedule_wrap(_inner_update)()

    return base
end

function MoveRandomXY:teardown(autocmd_callback_data)
	return { self.target_x, self.target_y } == vim.api.nvim_win_get_cursor(0)
end

function MoveRandomXY:description()
	return "Move to the random highlight"
end

return MoveRandomXY
