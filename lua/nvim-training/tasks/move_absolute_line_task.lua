local Task = require("nvim-training.task")

local MoveAbsoluteLine = Task:new({ target_line = 5, autocmd = "CursorMoved" })
MoveAbsoluteLine.__index = MoveAbsoluteLine

function MoveAbsoluteLine:setup()
	local function _inner_update()
		vim.api.nvim_win_set_cursor(0, { 7, 7 })
		-- self.highlight = utility.create_highlight(current_config.header_length + 2, 10, 12)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveAbsoluteLine:teardown(autocmd_callback_data)
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	-- utility.clear_highlight(self.highlight)
	return current_line == self.target_line
end

function MoveAbsoluteLine:description()
	return "Move to Line " .. self.target_line
end
return MoveAbsoluteLine
