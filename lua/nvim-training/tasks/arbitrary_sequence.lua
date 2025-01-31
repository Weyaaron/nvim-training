local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local ArbitrarySequenceTask = {}

ArbitrarySequenceTask.__index = ArbitrarySequenceTask
setmetatable(ArbitrarySequenceTask, { __index = Task })
ArbitrarySequenceTask.__metadata = { autocmd = "", desc = "", instructions = "", tags = "deletion," }

function ArbitrarySequenceTask:new()
	local base = Task:new()
	setmetatable(base, ArbitrarySequenceTask)
	base.target_text = ""
	base.seq_el = "abc"
	base.seq_counter = 1
	base.base_seq = {}
	return base
end
function ArbitrarySequenceTask:deactivate() end

return ArbitrarySequenceTask
