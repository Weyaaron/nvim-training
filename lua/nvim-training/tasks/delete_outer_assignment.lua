local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local tag_index = require("nvim-training.tag_index")
local template_index = require("nvim-training.template_index")
local treesitter = require("nvim-training.utilities.treesitter")

local DeleteOuterAssignment = {}
DeleteOuterAssignment.__index = DeleteOuterAssignment
setmetatable(DeleteOuterAssignment, { __index = Delete })
DeleteOuterAssignment.metadata = {
	autocmd = "TextChanged",
	desc = "Delete the current assignment.",
	instructions = "",
	tags = utility.flatten({ tag_index.deletion, tag_index.treesitter }),
	input_template = "", --Not set on purpose to skip tests, the current test do not cover treesitter tasks
}

function DeleteOuterAssignment:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteOuterAssignment })
	base.file_type = "lua"
	base.query_str = "(variable_declaration) @dec"
	return base
end

function DeleteOuterAssignment:construct_optional_header_args()
	return { _prefix_ = "--[[", _suffix_ = "--]]" }
end

function DeleteOuterAssignment:activate()
	local function _inner_update()
		utility.update_buffer_respecting_header(utility.load_raw_template(template_index.LuaAssignment))

		-- utility.do_treesitter_preparation("LuaAssignment", self.query_str)
		local query = treesitter.construct_query(self.query_str)
		local row_column_table = treesitter.execute_query(query, "start")
		self.target_text = treesitter.execute_query(query, "text")
		-- print("coordinates", vim.inspect(row_column_table))
		if #row_column_table > 0 then
			-- print("coordinates II", vim.inspect(row_column_table))
			vim.api.nvim_win_set_cursor(0, { row_column_table[1] + 1, row_column_table[2] })
		end
	end
	vim.schedule(_inner_update)
end

function DeleteOuterAssignment:instructions()
	return "Delete the outer Assignment" .. utility.construct_register_description(self.target_register) .. "."
end

return DeleteOuterAssignment
