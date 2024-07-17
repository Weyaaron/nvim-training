local user_config = {
	possible_marks_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" },
	possible_register_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" },
	bracket_pairs = { { "(", ")" }, { "{", "}" }, { "[", "]" } },
	audio_feedback = true,
	audio_feedback_success = function()
		os.execute("play media/click.flac 2> /dev/null")
	end,
	audio_feedback_failure = function()
		os.execute("play media/clack.flac 2> /dev/null")
	end,
}

return user_config
