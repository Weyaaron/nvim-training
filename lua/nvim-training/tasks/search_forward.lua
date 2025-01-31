local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local SearchForward = {}
SearchForward.__index = SearchForward

setmetatable(SearchForward, { __index = Task })
SearchForward.__metadata = {
	autocmd = "CursorMoved",
	desc = "Search forwards.",
	instructions = "",
	tags = { "search", "movement", "forward" },
}
function SearchForward:new()
	local base = Task:new()
	setmetatable(base, { __index = SearchForward })
	base.search_target = ""

	return base
end

function SearchForward:activate()
	local function _inner_update()
		local subword_length = 4
		local data_for_search = utility.construct_data_search(subword_length, 25, 55)
		utility.set_buffer_to_rectangle_with_line(data_for_search[1])
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], 5 })
		utility.construct_highlight(cursor_pos[1], data_for_search[3], subword_length)

		self.search_target = data_for_search[2]
		self.x_target = data_for_search[3]
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
