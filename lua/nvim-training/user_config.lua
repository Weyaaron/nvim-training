local user_config = {
	possible_marks_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" },
	possible_register_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" },
	bracket_pairs = { { "(", ")" }, { "{", "}" }, { "[", "]" } },
	audio_feedback = true,
	custom_collections = {},
	enable_counters = true,
	enable_events = true,
	base_path = vim.fn.stdpath("data") .. "/nvim-training/",
	task_alphabet = "ABCDEFGabddefg,.",
	counter_bounds = { 1, 5 },
}

return user_config
