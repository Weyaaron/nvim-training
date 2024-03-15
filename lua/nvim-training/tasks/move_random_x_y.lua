local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local current_config = require("nvim-training.current_config")

local MoveRandomXY = Task:new({
	target_x = math.random(current_config.header_length, current_config.header_length + 5),
	target_y = math.random(5, 25),
	autocmd = "CursorMoved",
})
MoveRandomXY.__index = MoveRandomXY

function MoveRandomXY:setup()
	local function _inner_update()
		local lorem_ipsum = utility.lorem_ipsum_lines()
		utility.update_buffer_respecting_header(lorem_ipsum)

		utility.move_cursor_to_random_point()
		self.highlight = utility.create_highlight(self.target_x, self.target_y, 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveRandomXY:teardown(autocmd_callback_data)
	return { self.target_x, self.target_y } == vim.api.nvim_win_get_cursor(0)
end

function MoveRandomXY:teardown_all_marks()
	for _, mark_el in pairs({ "a" }) do
		vim.api.nvim_buf_set_mark(0, mark_el, 0, 0, {})
	end
end
function MoveRandomXY:description()
	return "Move to the random highlight"
end

return MoveRandomXY
