local TextObject = {}
TextObject.__index = TextObject
TextObject.metadata = {}

function TextObject:new()
	local base = {}
	setmetatable(base, TextObject)
	return base
end

function TextObject:setup() end

function TextObject:beginning() end

function TextObject:_end() end

function TextObject:extract_text() end

--Todo: Add operators as methods
function TextObject:operate() end

return TextObject
