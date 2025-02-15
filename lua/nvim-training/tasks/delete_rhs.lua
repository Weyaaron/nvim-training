local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local tag_index = require("nvim-training.tag_index")
local template_index = require("nvim-training.template_index")

local DeleteRhs = {}
DeleteRhs.__index = DeleteRhs
setmetatable(DeleteRhs, { __index = Delete })
DeleteRhs.metadata = {
	autocmd = "TextChanged",
	desc = "Delete the lhs of the current assignment.",
	instructions = "",
	tags = utility.flatten({ tag_index.deletion, tag_index.treesitter }),
	input_template = "dal",
}

function DeleteRhs:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteRhs })
	base.file_type = "lua"
	base.query_str = " (variable_declaration (assignment_statement (variable_list)  (expression_list) @assignment.rhs))"
	return base
end
function DeleteRhs:construct_optional_header_args()
	return { _prefix_ = "--[[", _suffix_ = "--]]" }
end

function DeleteRhs:activate()
	local function _inner_update()
		utility.update_buffer_respecting_header(utility.load_raw_template(template_index.LuaConditional))
		utility.do_treesitter_preparation("LuaAssignment", self.query_str)
		self.target_text = utility.calculate_treesitter_target_text(self.query_str)
	end
	vim.schedule(_inner_update)
end

function DeleteRhs:instructions()
	return "Delete the lhs of the current assignment"
		.. utility.construct_register_description(self.target_register)
		.. "."
end

return DeleteRhs
