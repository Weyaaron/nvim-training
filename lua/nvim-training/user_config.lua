local user_config = {
	audio_feedback = true,
	base_path = vim.fn.stdpath("data") .. "/nvim-training/",
	bracket_pairs = { { "(", ")" }, { "{", "}" }, { "[", "]" } },
	counter_bounds = { 1, 5 },
	custom_collections = {},
	dev_mode = false,
	enable_counters = true,
	enable_events = true,
	enable_highlights = true,
	possible_marks_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" },
	possible_register_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" },
	scheduler_args = { repetitions = 5 },
	task_alphabet = "ABCDEFGabddefg,.",
	logging_args = {
		log_path = vim.fn.stdpath("log") .. "/nvim-training/" .. os.date("%Y-%M-%d") .. ".log",
		display_logs = false,
		display_warnings = true,
		skip_all = false,
	},
}
return user_config
