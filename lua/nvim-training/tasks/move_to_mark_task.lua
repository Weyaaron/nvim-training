local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local current_config = require("nvim-training.current_config")

local MoveToMark = Task:new({
	target_line = math.random(current_config.header_length, current_config.header_length + 5),
	autocmd = "CursorMoved",
	mark_names = "a",
})

--Todo: Remove the broken mark logic with only a single mark
MoveToMark.__index = MoveToMark

function MoveToMark:setup()
	local function _inner_update()
		local lorem_ipsum = utility.lorem_ipsum_lines()
		utility.update_buffer_respecting_header(lorem_ipsum)

		utility.move_cursor_to_random_point()
		vim.api.nvim_buf_set_mark(0, self.mark_name, self.target_line, 0, {})
		self.highlight = utility.create_highlight(current_config.header_length + 2, 10, 12)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveToMark:teardown(autocmd_callback_data)
	self:teardown_all_marks()
	utility.clear_highlight(self.highlight)
	return self.target_line == vim.api.nvim_win_get_cursor(0)[1]
end

function MoveToMark:teardown_all_marks()
	for _, mark_el in pairs({ "a" }) do
		vim.api.nvim_buf_set_mark(0, mark_el, 0, 0, {})
	end
end
function MoveToMark:description()
	return "Move to mark " .. self.mark_name
end

return MoveToMark
