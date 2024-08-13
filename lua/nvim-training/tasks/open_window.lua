local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")

local OpenWindow = {}
OpenWindow.__index = OpenWindow
setmetatable(OpenWindow, { __index = Task })
OpenWindow.__metadata = {
	autocmd = "WinNew",
	desc = "Open a new window.",
	instructions = "Open a new window.",
	tags = "window",
}

function OpenWindow:new()
	local base = Task:new()
	setmetatable(base, { __index = OpenWindow })
	return base
end

function OpenWindow:activate()
	local function _inner_update()
		utility.set_buffer_to_rectangle_and_place_cursor_randomly()
	end
	vim.schedule_wrap(_inner_update)()
end

function OpenWindow:deactivate()
	local function _inner_update()
		vim.loop.sleep(300)
		local windows = vim.api.nvim_list_wins()
		vim.api.nvim_win_close(windows[2], false)
	end
	vim.schedule_wrap(_inner_update)()
	return true
end

return OpenWindow
