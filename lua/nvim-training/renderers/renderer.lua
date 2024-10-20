local Renderer = {}
Renderer.__index = Renderer
Renderer.__metadata = {}

function Renderer:new()
	local base = {}
	setmetatable(base, Renderer)
	return base
end

function Renderer:render() end

function Renderer:body()
	--Ablaufplan: header, body, footer aufrufen von Rendern, die jeweils diese drei Methoden haben
	-- Methoden bekommen eine List von Key-Value-Paaren von Text, die dann zusamengesetzt werden können
	-- Das Ergebnis zusammenbauen
	-- Hl konstruieren: HL Definiton als Tuple (text, List von koordinatenpaaren  start end in der Zeile des Textes)
	-- Ergebnis: Den Buffer neu setzen
	-- Ablauf: Activate, render, deactivate
end

function Renderer:head()
	return ""
end

function Renderer:footer()
	return "footer_from_top_renderer"
end
return Renderer
