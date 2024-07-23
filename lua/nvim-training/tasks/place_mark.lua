local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")

local PlaceMark = {}
PlaceMark.__index = PlaceMark
setmetatable(PlaceMark, { __index = Task })
PlaceMark.__metadata = { autocmd = "CursorMoved", desc = "Place a mark", instructions = "", tags = "marks" }

function PlaceMark:new()
	local base = Task:new()
	setmetatable(base, { __index = PlaceMark })
	base.target_mark = "b"
	return base
end

function PlaceMark:activate()
	-- Creating a simple setInterval wrapper
	local function setInterval(interval, callback)
		local timer = vim.loop.new_timer()
		timer:start(interval, interval, function()
			callback()
		end)
		return timer
	end
	self.success = false
	setInterval(100, function()
		vim.schedule_wrap(function()
			local mark_pos = vim.fn.getpos("'" .. self.target_mark)
			local cursor_pos = vim.api.nvim_win_get_cursor(0)
			local is_placed = cursor_pos[1] == mark_pos[2] and cursor_pos[2] + 1 == mark_pos[3]
			if is_placed then
				self.success = true
				vim.api.nvim_exec_autocmds("CursorMoved", {})
			end
		end)()
	end)

	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
	end
	vim.schedule_wrap(_inner_update)()
end

function PlaceMark:deactivate(autocmd_callback_data)
	return self.success
end

function PlaceMark:instructions()
	return "Place the mark '" .. self.target_mark .. "'"
end

return PlaceMark
