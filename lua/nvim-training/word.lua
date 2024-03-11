local Word = {}
Word.__index = Word

function Word:new(args)
	local base = args or {}
	setmetatable(base, { __index = self })
	return base
end

return Word
