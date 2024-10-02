local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local SearchBackward = {}
SearchBackward.__index = SearchBackward

setmetatable(SearchBackward, { __index = Task })
SearchBackward.__metadata = {
	autocmd = "CursorMoved",
	desc = "Search backwards for a target-string.",
	instructions = "",
	tags = "search, movement, diagonal",
}
function SearchBackward:new()
	local base = Task:new()
	setmetatable(base, { __index = SearchBackward })
	base.search_target = ""

	return base
end

function SearchBackward:activate()
	local function _inner_update()
		local subword_length = 4
		local initial_cursor_pos = 55
		local data_for_search = utility.construct_data_search(subword_length, 0, 30)
		utility.set_buffer_to_rectangle_with_line(data_for_search[1])
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], initial_cursor_pos })
		utility.construct_highlight(cursor_pos[1], data_for_search[3], subword_length)

		self.search_target = data_for_search[2]
		self.x_target = data_for_search[3]
	end
	vim.schedule_wrap(_inner_update)()
end

function SearchBackward:deactivate(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	vim.schedule_wrap(function()
		vim.cmd("noh")
	end)()
	local res = cursor_pos[2] == self.x_target
	print(res, cursor_pos[2], self.x_target)
	return res
end

function SearchBackward:instructions()
	return "Search backwards for '" .. self.search_target .. "'"
end

return SearchBackward
