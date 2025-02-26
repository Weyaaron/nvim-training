require("./minimal_init.lua")

local config = {
	possible_marks_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" }, --A list of possible marks. (Optional, this is the default)
	dev_mode = true, -- A flag to enable developer mode. WARNING: May break the plugin temporarily.
	possible_register_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" }, -- A list of possible registers. (Optional, this the default)
	audio_feedback = true, --Enables/Disables audio feedback, if enabled, requires the 'sox' package providing the 'play' command.
	enable_counters = true, --Enables/Disables counters in tasks that support counters.
	-- custom_collections = { Testing = { "YankF", "Yankf", "YankT", "Yankt" } },
	-- custom_collections = { Testing = { "DeleteWord", "MoveWord" }, f = { "a" } },
	disabled_collections = {},
	disabled_tags = {},
	custom_collections = { Testing = { "DeleteInnerConditional" } },
	-- screen_layout = "basic",
	screen_layout = "minimal",
	counter_bounds = { 3, 5 }, --The outer bounds for counters used in some tasks. WARNING: A high value may result in glitchy behaviour.
	scheduler_args = { repetitions = 3 },
	enable_highlights = true,
	enable_registers = false,
	enable_events = false,
	-- event_storage_diretory_path = vim.fn.stdpath("data"),
	event_storage_diretory_path = "/data",
	logging_args = {

		-- log_directory_path = vim.fn.stdpath("log") .. "/nvim-training/",
		-- log_directory_path = "/madeup",
		log_directory_path = nil,
		log_file_path = os.date("%Y-%m-%d") .. ".log",
		display_logs = true,
		display_warnings = true,
		enable_logging = true,
		skip_none = true,
	},
}

require("nvim-training").setup(config)
vim.cmd("Training Start RandomScheduler All")
