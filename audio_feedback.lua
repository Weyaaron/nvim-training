local function play_levelup_sound()
    os.execute("play media/ding.flac 2> /dev/null")
end
local function play_success_sound()
    os.execute("play media/click.flac 2> /dev/null")
end
local function play_failure_sound()
    os.execute("play media/clack.flac 2> /dev/null")
end