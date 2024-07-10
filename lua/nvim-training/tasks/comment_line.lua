local LuaTask = require("nvim-training.tasks.lua_task")
local utility = require("nvim-training.utility")
local internal_config = require("nvim-training.internal_config")
local template_index = require("nvim-training.template_index")

local CommentLine = LuaTask:new()
CommentLine.__index = CommentLine
function CommentLine:new()
	local base = LuaTask:new()
	setmetatable(base, { __index = CommentLine })
	base.search_target = ""
	base.position = { 15, 5 }

	base.autocmd = "TextChanged"

	local function _inner_update()
		vim.cmd("sil e training.lua")
		local lua_text = template_index.LuaFunctions

		local line_size = 70

		local line_array = {}
		for i = 1, #lua_text, line_size do
			local current_text = string.sub(lua_text, i, i + line_size)
			line_array[#line_array + 1] = current_text
		end
		local result = table.concat(line_array, "\n")
		utility.update_buffer_respecting_header(result)

		vim.api.nvim_win_set_cursor(0, { 6, 7 })
	end
	vim.schedule_wrap(_inner_update)()

	return base
end

function CommentLine:teardown(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local new_line = utility.get_line(cursor_pos[1] - 1)
	return new_line:sub(1, 2) == "--"
end

function CommentLine:description()
	return "Change the current line into a single line comment"
end

return CommentLine
