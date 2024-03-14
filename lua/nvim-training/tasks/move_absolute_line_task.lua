local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local current_config = require("nvim-training.current_config")

local MoveAbsoluteLine = Task:new({
	target_line = math.random(current_config.header_length, current_config.header_length + 5),
	autocmd = "CursorMoved",
})
MoveAbsoluteLine.__index = MoveAbsoluteLine

function MoveAbsoluteLine:setup()
	local function _inner_update()
		utility.move_cursor_to_random_point()

		-- self.highlight = utility.create_highlight(current_config.header_length + 2, 10, 12)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveAbsoluteLine:teardown(autocmd_callback_data)
	-- utility.clear_highlight(self.highlight)
	return self.target_line == vim.api.nvim_win_get_cursor(0)[1]
end

function MoveAbsoluteLine:description()
	return "Move to Line " .. self.target_line
end
