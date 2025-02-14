local Move = require("nvim-training.tasks.move")
local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")
local internal_config = require("nvim-training.internal_config")
local tag_index = require("nvim-training.tag_index")

local MoveWORD = {}
MoveWORD.__index = MoveWORD
setmetatable(MoveWORD, { __index = Move })
MoveWORD.metadata = {
	autocmd = "CursorMoved",
	desc = "Move multiple WORDS.",
	instructions = "",
	tags = utility.flatten({ tag_index.movement, tag_index.WORD }),
	input_template = "<counter>W",
}

function MoveWORD:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveWORD })

	return base
end

function MoveWORD:activate()
	local function _inner_update()
		local line = utility.construct_WORDS_line()
		self.cursor_target = utility.do_word_preparation(line, movements.WORDS, self.counter, math.random(1, 10))
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveWORD:instructions()
	return "Move " .. self.counter .. " WORD(s)."
end
return MoveWORD
