local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local internal_config = require("nvim-training.internal_config")
local template_index = require("nvim-training.template_index")
local MoveFunctions = {}
MoveFunctions.__index = MoveFunctions
function MoveFunctions:new()
	local base = Task:new()
	setmetatable(base, { __index = MoveFunctions })
	self.search_target = ""
	self.position = { 15, 5 }
	vim.cmd("e training.lua")

	self.autocmd = "CursorMoved"

	local function _inner_update()
		local lua_text = template_index.LuaFunctions

		local line_size = 70

		local line_array = {}
		for i = 1, #lua_text, line_size do
			local current_text = string.sub(lua_text, i, i + line_size)
			line_array[#line_array + 1] = current_text
		end
		local result = table.concat(line_array, "\n")
		utility.update_buffer_respecting_header(result)

		vim.api.nvim_win_set_cursor(0, { 7, 7 })
	end
	vim.schedule_wrap(_inner_update)()

	return base
end

function MoveFunctions:teardown(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	print(cursor_pos[1], cursor_pos[2])
	return false
end

function MoveFunctions:description()
	return "Search for '" .. self.search_target .. "'"
end

return MoveFunctions
