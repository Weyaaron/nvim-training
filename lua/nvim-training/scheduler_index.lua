local exported_schedulers = {
	RandomScheduler = require("nvim-training.random_scheduler"),
	ArbitrarySequenceScheduler = require("nvim-training.schedulers.repeat_n_success_scheduler"),
	RepeatNScheduler = require("nvim-training.schedulers.repeat_n_scheduler"),
	ArbritrarySequenceScheduler= require("nvim-training.schedulers.arbritrary_sequence_scheduler"),
}

return exported_schedulers
