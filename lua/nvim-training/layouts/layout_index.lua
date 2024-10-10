local basic_layout_values = {
	_header_ = "Status",
	_succes_counter_ = 0,
	_failure_counter_ = 0,
	_desc_ = "Empty Description",
	_streak_ = 0,
	_maxstreak_ = 0,
	_prefix_ = "",
	_suffix_ = "",
	_task_str_ = "",
}
local basic_layout =
	"_prefix_------_header_-------\nYour next Task: _desc_\nSuccesses: _succes_counter_, Failures: _failure_counter_\nCurrent Streak: _streak_ Your best Streak: _maxstreak_\n_task_str_\n--------------_suffix_"

local footer_layout =
	"_prefix_\n_task_str_\nYour next Task: _desc_\nSuccesses: _succes_counter_, Failures: _failure_counter_\nCurrent Streak: _streak_ Your best Streak: _maxstreak_\n--------------_suffix_"

local minimal_layout_values = {
	_header_ = "Workbench",
	_desc_ = "Empty Description",
	_prefix_ = "",
	_suffix_ = "",
	_task_str_ = "",
}
local minimal_template = "_desc_\n_task_str_\n"

local minimal = { name = "minimal", values = minimal_layout_values, template = minimal_template }

local basic = { name = "basic", values = basic_layout_values, template = basic_layout }
local footer = { name = "footer", values = basic_layout_values, template = footer_layout }

return { basic = basic, minimal = minimal, footer = footer }
