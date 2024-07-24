local TaskLua = require("nvim-training.tasks.task_lua")
local utility = require("nvim-training.utility")
local template_index = require("nvim-training.template_index")

local CommentLineBlock = {}
CommentLineBlock.__index = CommentLineBlock

setmetatable(CommentLineBlock, { __index = TaskLua })
CommentLineBlock.__metadata = {
	autocmd = "TextChanged",
	desc = "Change the current line into a block comment.",
	instructions = "Change the current line into a block comment.",
	notes = "This assumes the use of a plugin, it is not tested with the buildin-commenting-feature. ",
	tags = "comment, programming, plugin, change",
}
function CommentLineBlock:new()
	local base = TaskLua:new()
	setmetatable(base, { __index = CommentLineBlock })

	return base
end
function CommentLineBlock:activate()
	local function _inner_update()
		vim.cmd("sil e training.lua")
		utility.update_buffer_respecting_header(utility.load_template(template_index.LuaFunctions))

		vim.api.nvim_win_set_cursor(0, { 6, 7 })
	end
	vim.schedule_wrap(_inner_update)()
end

function CommentLineBlock:deactivate()
	local new_line = utility.get_line(vim.api.nvim_win_get_cursor(0)[1])
	return new_line:sub(1, 4) == "--[["
end

return CommentLineBlock
