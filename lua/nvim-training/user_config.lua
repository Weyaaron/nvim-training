local user_config = {
	possible_marks_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" },
	possible_register_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" },
	bracket_pairs = { { "(", ")" }, { "{", "}" }, { "[", "]" } },
	audio_feedback = true,
	custom_collections = {},
	enable_counters = true,
	enable_events = true,
	--This is a fix for the problem that  ~ may not resolve properly. According to
	--https://pubs.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap08.html
	-- home must be set on a posic system.
	base_path = os.getenv("HOME") .. "/Training-Events/",
	task_alphabet = "ABCDEFGabddefg,.",
	counter_bounds = { 1, 5 },
}

return user_config
