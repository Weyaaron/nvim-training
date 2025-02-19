local TextObject = require("nvim-training.text_object")

local fTextObject = {}
fTextObject.__index = fTextObject
fTextObject.metadata = {}

function fTextObject:new()
	local base = TextObject:new()
	setmetatable(base, fTextObject)
	return base
end

function fTextObject:setup(target_char)
	print("got called in f obj setup")
end

function fTextObject:beginning() end

function fTextObject:_end() end

function fTextObject:extract_text() end

--Todo: Add operators as methods
function fTextObject:operate() end

return fTextObject
