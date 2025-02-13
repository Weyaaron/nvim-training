local user_config = {
	audio_feedback = true,
	bracket_pairs = { { "(", ")" }, { "{", "}" }, { "[", "]" } },
	counter_bounds = { 10, 20 },
	custom_collections = {},
	dev_mode = false,
	disabled_tags = { "treesitter" },
	disabled_collections = { "Treesitter-Tasks" },
	enable_counters = true,
	enable_events = true,
	enable_highlights = true,
	enable_repeat_on_failure= false,
	event_storage_directory_path = vim.fn.stdpath("data") .. "/nvim-training/", -- The path used to store events.
	enable_registers = false,
	possible_marks_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" },
	possible_register_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" },
	scheduler_args = { repetitions = 5 },
	task_alphabet = "ABCDEFGabddefg,.",
	quotes = { '"', "'" },
	logging_args = {
		enable_logging = true,
		--According to https://neovim.io/doc/user/starting.html#_standard-paths, as of 2025-01, log currently points to state.
		-- Splitting the path from the name has been done to support to support checks for the existence of the directory.
		log_directory_path = vim.fn.stdpath("log") .. "/nvim-training/",
		log_file_path = os.date("%Y-%m-%d") .. ".log",
		display_logs = false,
		display_warnings = true,
	},
}
return user_config
