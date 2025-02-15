local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local tag_index = require("nvim-training.tag_index")
local template_index = require("nvim-training.template_index")

local DeleteInnerConditional = {}
DeleteInnerConditional.__index = DeleteInnerConditional
setmetatable(DeleteInnerConditional, { __index = Delete })
DeleteInnerConditional.metadata = {
	autocmd = "TextChanged",
	desc = "Delete the condition of the current conditional.",
	instructions = "",
	tags = utility.flatten({ tag_index.deletion, tag_index.treesitter }),
	input_template = "", --Not set on purpose to skip tests, the current test do not cover treesitter tasks
}

function DeleteInnerConditional:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteInnerConditional })
	base.file_type = "lua"
	base.query_str = "(if_statement condition: (_) @conditional.inner)"
	return base
end

function DeleteInnerConditional:construct_optional_header_args()
	return { _prefix_ = "--[[", _suffix_ = "--]]" }
end

function DeleteInnerConditional:activate()
	local function _inner_update()
		utility.update_buffer_respecting_header(utility.load_raw_template(template_index.LuaConditional))
		utility.do_treesitter_preparation("LuaConditional", self.query_str)
		self.target_text = utility.calculate_treesitter_target_text(self.query_str)
	end
	vim.schedule(_inner_update)
end

function DeleteInnerConditional:instructions()
	return "Delete the current condition" .. utility.construct_register_description(self.target_register) .. "."
end

return DeleteInnerConditional
