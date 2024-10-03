local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local SearchWordForward = {}
SearchWordForward.__index = SearchWordForward

setmetatable(SearchWordForward, { __index = Task })
SearchWordForward.__metadata = {
	autocmd = "CursorMoved",
	desc = "Search forwards for the word at the cursor.",
	instructions = "",
	tags = "search, movement, forward",
}
function SearchWordForward:new()
	local base = Task:new()
	setmetatable(base, { __index = SearchWordForward })
	base.search_target = ""

	return base
end

function SearchWordForward:activate()
	local function _inner_update()
		local subword_length = 4
		local initial_cursor_pos = 5
		local data_for_search = utility.construct_data_search(subword_length, 25, 55)
		local initial_line = data_for_search[1]
		utility.set_buffer_to_rectangle_with_line(data_for_search[1])

		local cursor_pos = vim.api.nvim_win_get_cursor(0)

		local new_line = initial_line:sub(1, initial_cursor_pos)
			.. " "
			.. data_for_search[2]
			.. " "
			.. initial_line:sub(initial_cursor_pos + subword_length, #initial_line)
		utility.set_buffer_to_rectangle_with_line(new_line)

		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], initial_cursor_pos + 1 })

		cursor_pos = vim.api.nvim_win_get_cursor(0)
		utility.construct_highlight(cursor_pos[1], data_for_search[3] + 1, subword_length)

		self.search_target = data_for_search[2]
		self.x_target = data_for_search[3] + 3 --Since we added two spaces we need to compensate accordingly.
	end
	vim.schedule_wrap(_inner_update)()
end

function SearchWordForward:deactivate()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	vim.schedule_wrap(function()
		vim.cmd("noh")
	end)()
	return cursor_pos[2] == self.x_target
end

function SearchWordForward:instructions()
	return "Search for the word unter the cursor: '" .. self.search_target .. "'"
end

return SearchWordForward
