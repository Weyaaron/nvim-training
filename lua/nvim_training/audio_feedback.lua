local Config = require("nvim_training.config")
local AudioInterface = {}
AudioInterface.__index = AudioInterface

function AudioInterface:new()
	self.__index = self
	local base = {}
	setmetatable(base, {__index=self})

	local current_config = Config:new()
	base.enable_audio_feedback = current_config.enable_audio_feedback
	return base
end

function AudioInterface:play_levelup_sound()
	if self.enable_audio_feedback then
		os.execute("play media/ding.flac 2> /dev/null")
	end
end

function AudioInterface:play_success_sound()
	if self.enable_audio_feedback then
		print("Audio called")
		os.execute("play media/click.flac 2> /dev/null")
	end
	print("Audio failed")
end
function AudioInterface:play_failure_sound()
	if self.enable_audio_feedback then
		os.execute("play media/clack.flac 2> /dev/null")
	end
end

return AudioInterface
