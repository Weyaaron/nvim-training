local Move = require("nvim-training.tasks.move")
local utility = require("nvim-training.utility")
local template_index = require("nvim-training.template_index")

local MoveFunctions = {}
MoveFunctions.__index = MoveFunctions
setmetatable(MoveFunctions, { __index = Move })

MoveFunctions.metadata = {
	autocmd = "CursorMoved",
	desc = "Move around function objects.",
	instructions = "Move to the start of the current function",
	tags = { "programming", "plugin", "movement", "function" },
}

function MoveFunctions:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveFunctions })
	return base
end

function MoveFunctions:construct_optional_header_args()
	--This is used to turn the header in lua tasks into a block comment
	return { _prefix_ = "--[[", _suffix_ = "--]]" }
end
function MoveFunctions:activate()
	local function _inner_update()
		vim.cmd("e training.lua")
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

		local ts_module = require("nvim-training.treesitter")
		local root = ts_module.parse_into_root()
		local indexes = ts_module.parse_func_start_indexes(root)
		self.cursor_target = { indexes[1][1][1], indexes[1][1][1] }
	end
	vim.schedule_wrap(_inner_update)()
end

return MoveFunctions
