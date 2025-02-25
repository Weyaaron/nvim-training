local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local SearchForward = {}
SearchForward.__index = SearchForward

setmetatable(SearchForward, { __index = Task })
SearchForward.metadata = {
	autocmd = "CursorMoved",
	desc = "Search forwards.",
	instructions = "",
	tags = { "search", "movement", "forward" },
	input_template = "/<search_target><enter>",
}
function SearchForward:new()
	local base = Task:new()
	setmetatable(base, { __index = SearchForward })
	base.search_target = ""

	base.subword_length = 4
	base.data_for_search = utility.construct_data_search(base.subword_length, 25, 55)
	base.search_target = base.data_for_search[2]
	base.x_target = base.data_for_search[3]
	return base
end

function SearchForward:activate()
	local function _inner_update()
		utility.set_buffer_to_rectangle_with_line(self.data_for_search[1])
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], 5 })
		utility.construct_highlight(cursor_pos[1], self.data_for_search[3], self.subword_length)
	end
	vim.schedule_wrap(_inner_update)()
end

function SearchForward:deactivate()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	vim.schedule_wrap(function()
		vim.cmd("noh")
	end)()
	return cursor_pos[2] == self.x_target
end

function SearchForward:instructions()
	return "Search forwards for '" .. self.search_target .. "'"
end

return SearchForward
