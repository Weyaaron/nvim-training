local Movement = {}
Movement.__index = Movement

Movement.base_args = {}

function Movement:new(custom_args)
	self.__index = self
	local base = {}
	if not custom_args then
		custom_args = self.base_args
	end
	for i, v in pairs(self.base_args) do
		if not custom_args[i] then
			base[i] = v
		end
	end
	setmetatable(base, self)

	for i, v in pairs(custom_args) do
		base[i] = v
	end
	return base
end
function Movement:_prepare_calculation()
	local max_lines = vim.api.nvim_buf_line_count(0)
	local buffer_as_lines = vim.api.nvim_buf_get_lines(0, max_lines, -1, false)
	self.str_as_single_line = nil
	self.line_indexes = {}

	for i, line_el in pairs(buffer_as_lines) do
		self.str_as_single_line = self.str_as_single_line .. line_el
		table.insert(self.line_indexes, #self.str_as_single_line)
	end
end
function Movement:_execute_calculation()
	return { 5, 9 }
end

function Movement:calculate_cursor_x_y()
	self:_prepare_calculation()
	return self:_execute_calculation()
end

return Movement
