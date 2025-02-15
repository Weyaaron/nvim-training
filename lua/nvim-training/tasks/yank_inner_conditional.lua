local utility = require("nvim-training.utility")
local Yank = require("nvim-training.tasks.yank")
local tag_index = require("nvim-training.tag_index")
local template_index = require("nvim-training.template_index")

local YankInnerConditional = {}
YankInnerConditional.__index = YankInnerConditional
setmetatable(YankInnerConditional, { __index = Yank })
YankInnerConditional.metadata = {
	autocmd = "TextYankPost",
	desc = "Yank the condition of the current conditional.",
	instructions = "",
	tags = utility.flatten({ tag_index.yank, tag_index.treesitter }),
}

function YankInnerConditional:new()
	local base = Yank:new()
	setmetatable(base, { __index = YankInnerConditional })
	base.file_type = "lua"
	base.query_str = "(if_statement condition: (_) @conditional.inner)"
	return base
end

function YankInnerConditional:construct_optional_header_args()
	return { _prefix_ = "--[[", _suffix_ = "--]]" }
end

function YankInnerConditional:activate()
	local function _inner_update()
		utility.update_buffer_respecting_header(utility.load_raw_template(template_index.LuaConditional))
		utility.do_treesitter_preparation("LuaConditional", self.query_str)
		self.target_text = utility.calculate_treesitter_target_text(self.query_str)
	end
	vim.schedule(_inner_update)
end

function YankInnerConditional:instructions()
	return "Yank the current condition" .. utility.construct_register_description(self.target_register) .. "."
end

return YankInnerConditional
