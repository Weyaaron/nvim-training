local user_config = {
	audio_feedback = true,
	base_path = vim.fn.stdpath("data") .. "/nvim-training/",
	bracket_pairs = { { "(", ")" }, { "{", "}" }, { "[", "]" } },
	counter_bounds = { 1, 5 },
	custom_collections = {},
	enable_counters = true,
	enable_events = true,
	possible_marks_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" },
	possible_register_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" },
	scheduler_args = { repetitions = 5 },
	task_alphabet = "ABCDEFGabddefg,.",
}

return user_config
