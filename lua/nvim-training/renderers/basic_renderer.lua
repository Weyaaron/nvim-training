local Renderer = require("nvim-training.renderers.renderer")
local BasicRenderer = {}

BasicRenderer.__index = BasicRenderer
setmetatable(BasicRenderer, { __index = Renderer })
BasicRenderer.__metadata = { autocmd = "", desc = "", instructions = "" }

function BasicRenderer:new()
	local base = Renderer:new()
	setmetatable(base, BasicRenderer)

	return base
end

function BasicRenderer:head()
	return "head"
end
function BasicRenderer:body()
	return "body"
end

return BasicRenderer
