local exported_schedulers = {
	RandomScheduler = require("nvim-training.random_scheduler"),
	RepeatNSuccessScheduler = require("nvim-training.schedulers.repeat_n_success_scheduler"),
	RepeatNScheduler = require("nvim-training.schedulers.repeat_n_scheduler"),
}

return exported_schedulers
