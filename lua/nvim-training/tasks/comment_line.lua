local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local template_index = require("nvim-training.template_index")
local tag_index = require("nvim-training.tag_index")

local CommentLine = {}
CommentLine.__index = CommentLine
setmetatable(CommentLine, { __index = Task })
CommentLine.metadata = {
	autocmd = "TextChanged",
	desc = "Change the current line into a single line comment.",
	instructions = "Change the current line into a single line comment.",
	tags = utility.flatten({ tag_index.change, "plugin", "commenting" }),
	input_template = "gcc",
}
function CommentLine:new()
	local base = Task:new()
	setmetatable(base, { __index = CommentLine })
	base.file_type = "lua"
	return base
end

function CommentLine:construct_optional_header_args()
	--This is used to turn the header in lua tasks into a block comment
	return { _prefix_ = "--[[", _suffix_ = "--]]" }
end

function CommentLine:activate()
	local function _inner_update()
		utility.update_buffer_respecting_header(utility.load_line_template(template_index.LuaFunctions))

		vim.api.nvim_win_set_cursor(0, { 6, 7 })
	end
	vim.schedule_wrap(_inner_update)()
end

function CommentLine:deactivate()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local new_line = utility.get_line(cursor_pos[1])

	return new_line:sub(1, 2) == "--"
end

return CommentLine
