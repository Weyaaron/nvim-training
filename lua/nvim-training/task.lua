local utility = require("nvim-training.utility")
local Task = {}
Task.__index = Task
Task.__metadata = {}

function Task:new()
	local base = {}
	setmetatable(base, Task)
	--This is usefull for such a huge swath of tasks that this is worthwile
	base.counter = utility.calculate_counter()

	base.cursor_target = { 0, 0 }
	base.target_char = utility.calculate_target_char()
	base.cursor_center_pos = utility.calculate_center_cursor_pos()

	return base
end

function Task:activate() end

function Task:metadata()
	return self.__metadata
end
function Task:deactivate(autocmd_callback_data) end

function Task:instructions()
	return self.__metadata.instructions
end

function Task:render()
	local basicRenderer = require("nvim-training.renderers.basic_renderer")
	local br = basicRenderer:new()
	local head = br:head()
	local body = br:body()
	local footer = br:footer()
	local full_table = { head, body, footer } --Todo: Deal with more lines in result?

	vim.api.nvim_buf_set_lines(0, 0, 0, false, {})
	vim.api.nvim_buf_set_lines(0, 0, #full_table, false, full_table)
	--Ablaufplan: header, body, footer aufrufen von Rendern, die jeweils diese drei Methoden haben
	-- Methoden bekommen eine List von Key-Value-Paaren von Text, die dann zusamengesetzt werden können
	-- Das Ergebnis zusammenbauen
	-- Hl konstruieren: HL Definiton als Tuple (text, List von koordinatenpaaren  start end in der Zeile des Textes)
	-- Ergebnis: Den Buffer neu setzen
	-- Ablauf: Activate, render, deactivate
end

function Task:construct_optional_header_args()
	--This might someday be merged with description, but remains a special case for the time being.
	return {}
end

return Task
