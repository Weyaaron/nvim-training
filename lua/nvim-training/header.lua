local header = {}

local utility = require("nvim-training.utility")
local internal_config = require("nvim-training.internal_config")
local default_header_values = {
	_h = "Status",
	_s_ = 0,
	_f_ = 0,
	_d_ = "Empty Description",
	_streak_ = 0,
	_maxstreak_ = 0,
	_prefix_ = "",
	_suffix_ = "",
}

local current_header_values = {}
function header.reset()
	for i, v in pairs(default_header_values) do
		current_header_values[i] = v
	end
end

local initial_header =
	"_prefix_------_h-------\nYour next Task: _d_\nSuccesses: _s_, Failures: _f_\nCurrent Streak: _streak_ Your best Streak: _maxstreak_\n--------------_suffix_"

function header.clear_highlight(highlight_obj)
	vim.api.nvim_buf_clear_namespace(0, highlight_obj.highlight_namespace, 0, -1)
end

function header.store_key_value_in_header(key, value)
	current_header_values[key] = value
end

function header.construct_header()
	local constructed_header = initial_header

	for key, el in pairs(current_header_values) do
		constructed_header = string.gsub(constructed_header, key, el)
	end
	local str_as_lines = utility.split_str(constructed_header, "\n")

	vim.api.nvim_buf_set_lines(internal_config.buf_id, 0, internal_config.header_length, false, str_as_lines)
end

return header
