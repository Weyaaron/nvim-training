local function construct_base_path()
	--https://stackoverflow.com/questions/6380820/get-containing-path-of-lua-file
	local function script_path()
		local str = debug.getinfo(2, "S").source:sub(2)
		local initial_result = str:match("(.*/)")
		return initial_result
	end

	local base_path = script_path() .. "../.."
	return base_path
end
local audio = {
	audio_feedback_success = function()
		os.execute("play " .. tostring(construct_base_path()) .. "/media/click.flac 2> /dev/null")
	end,
	audio_feedback_failure = function()
		os.execute("play " .. tostring(construct_base_path()) .. "/media/clack.flac 2> /dev/null")
	end,
}
return audio
