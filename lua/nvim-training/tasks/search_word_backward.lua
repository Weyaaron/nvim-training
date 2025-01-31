local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local SearchWordBackward = {}
SearchWordBackward.__index = SearchWordBackward

setmetatable(SearchWordBackward, { __index = Task })
SearchWordBackward.__metadata = {
	autocmd = "CursorMoved",
	desc = "Search backwards for the word at the cursor.",
	instructions = "",
	tags = { "search", "movement", "backward" },
}
function SearchWordBackward:new()
	local base = Task:new()
	setmetatable(base, { __index = SearchWordBackward })
	base.search_target = ""

	return base
end

function SearchWordBackward:activate()
	local function _inner_update()
		local subword_length = 4
		local initial_cursor_pos = 55
		local data_for_search = utility.construct_data_search(subword_length, 0, 30)
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
		utility.construct_highlight(cursor_pos[1], data_for_search[3], subword_length)

		self.search_target = data_for_search[2]
		self.x_target = data_for_search[3]
	end
	vim.schedule_wrap(_inner_update)()
end

function SearchWordBackward:deactivate()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	vim.schedule_wrap(function()
		vim.cmd("noh")
	end)()
	return cursor_pos[2] == self.x_target
end

function SearchWordBackward:instructions()
	return "Search for the word unter the cursor: '" .. self.search_target .. "'"
end

return SearchWordBackward
