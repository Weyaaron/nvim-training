local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")

local PlaceMark = Task:new()
PlaceMark.__index = PlaceMark

function PlaceMark:new()
	local base = Task:new()
	setmetatable(base, { __index = PlaceMark })
	base.target_mark = "b"
	-- Creating a simple setInterval wrapper
	local function setInterval(interval, callback)
		local timer = vim.loop.new_timer()
		timer:start(interval, interval, function()
			callback()
		end)
		return timer
	end
	base.success = false
	setInterval(100, function()
		vim.schedule_wrap(function()
			local mark_pos = vim.fn.getpos("'" .. base.target_mark)
			local cursor_pos = vim.api.nvim_win_get_cursor(0)
			local is_placed = cursor_pos[1] == mark_pos[2] and cursor_pos[2] + 1 == mark_pos[3]
			print(cursor_pos[1], mark_pos[2], cursor_pos[2], mark_pos[3], is_placed)
			if is_placed then
				base.success = true
				vim.api.nvim_exec_autocmds("CursorMoved", {})
			end
		end)()
	end)

	base.autocmd = "CursorMoved"

	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
	end
	vim.schedule_wrap(_inner_update)()

	return base
end

function PlaceMark:teardown(autocmd_callback_data)
	return self.success
end

function PlaceMark:description()
	return "Place the mark '" .. self.target_mark .. "'"
end

return PlaceMark
