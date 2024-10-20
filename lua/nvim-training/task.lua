local utility = require("nvim-training.utility")

local interface_names =
	{ "counter", "target_char", "name", "target_register", "input_template", "search_target", "target_quote" }

local Task = {}
Task.__index = Task
Task.metadata = {}

function Task:new()
	local base = {}
	setmetatable(base, Task)
	--This is usefull for such a huge swath of tasks that this is worthwile
	base.counter = utility.calculate_counter()

	base.cursor_target = { 0, 0 }
	base.target_char = utility.calculate_target_char()
	base.cursor_center_pos = utility.calculate_center_cursor_pos()
	base.file_type = "txt"

	base.target_register = utility.calculate_target_register()
	vim.fn.setreg(base.target_register, "")
	return base
end

function Task:read_register()
	local register_content = vim.fn.getreg(self.target_register)
	return utility.split_str(register_content, "\n")[1]
end

function Task:construct_interface_data()
	local result = {}
	for i, v in pairs(interface_names) do
		result[v] = self.metadata[v] or self[v]
	end
	return result
end

function Task:activate() end

function Task:deactivate(autocmd_callback_data) end

function Task:instructions()
	return self.metadata.instructions
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
