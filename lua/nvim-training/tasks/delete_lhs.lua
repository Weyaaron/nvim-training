local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local tag_index = require("nvim-training.tag_index")
local template_index = require("nvim-training.template_index")

local DeleteLhs = {}
DeleteLhs.__index = DeleteLhs
setmetatable(DeleteLhs, { __index = Delete })
DeleteLhs.metadata = {
	autocmd = "TextChanged",
	desc = "Delete the lhs of the current assignment.",
	instructions = "",
	tags = utility.flatten({ tag_index.deletion, tag_index.treesitter }),
	input_template = "", --Not set on purpose to skip tests, the current test do not cover treesitter tasks
}

function DeleteLhs:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteLhs })
	base.file_type = "lua"
	base.query_str =
		" (variable_declaration (assignment_statement (variable_list) @assignment.lhs (expression_list) @assignment.inner @assignment.rhs)) @assignment.outer"
	return base
end
function DeleteLhs:construct_optional_header_args()
	return { _prefix_ = "--[[", _suffix_ = "--]]" }
end

function DeleteLhs:activate()
	local function _inner_update()
		utility.update_buffer_respecting_header(utility.load_raw_template(template_index.LuaConditional))
		utility.do_treesitter_preparation("LuaAssignment", self.query_str)
		self.target_text = utility.calculate_treesitter_target_text(self.query_str)
	end
	vim.schedule(_inner_update)
end

function DeleteLhs:instructions()
	return "Delete the lhs of the current assignment"
		.. utility.construct_register_description(self.target_register)
		.. "."
end

return DeleteLhs
