local utility = require("nvim-training.utility")
local audio = {
	audio_feedback_success = function()
		os.execute("play " .. tostring(utility.construct_base_path()) .. "/media/click.flac 2> /dev/null")
	end,
	audio_feedback_failure = function()
		os.execute("play " .. tostring(utility.construct_base_path()) .. "/media/clack.flac 2> /dev/null")
	end,
}
return audio
