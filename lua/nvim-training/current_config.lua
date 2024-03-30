local config = {
	header_length = 5,
	buffer_length = 20,
	exmark_name_space = vim.api.nvim_create_namespace("nvim-training"),
	task_list = {},
	possible_marks_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" },
	possible_register_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" },
	task_scheduler = "",
	task_scheduler_kwargs = {},
}

return config
