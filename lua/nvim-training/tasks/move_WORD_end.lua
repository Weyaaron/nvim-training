local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local internal_config = require("nvim-training.internal_config")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local MoveWORDEnd = {}
MoveWORDEnd.__index = MoveWORDEnd
setmetatable(MoveWORDEnd, { __index = Move })
MoveWORDEnd.metadata = {
	autocmd = "CursorMoved",
	desc = "Move to the end of WORDs.",
	instructions = "",
	tags = utility.flatten({ tag_index.movement, tag_index.WORD_end }),
	input_template = "<counter>E",
}

function MoveWORDEnd:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveWORDEnd })
	return base
end
function MoveWORDEnd:activate()
	local function _inner_update()
		local line = utility.construct_WORDS_line()
		self.cursor_target = utility.do_word_preparation(line, movements.WORD_end, self.counter, math.random(1, 10))

	end
	vim.schedule_wrap(_inner_update)()
end

function MoveWORDEnd:instructions()
	return "Move to the end of " .. self.counter .. " 'WORDS'."
end

return MoveWORDEnd
