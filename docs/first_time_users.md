# Some Advice for first time users


Hi, welcome. This additional guide covers some low hanging
fruits to dial the difficulty to a pleasant level.
No level is to low, just get started with what works for you.


To recap, these are some the default settings and how to set them in your init.lua:
```lua
local training = require("nvim-training")
training.configure({ -- All of these options work for 'opts' of lazy as well.
	counter_bounds = { 1, 5 }, --The outer bounds for counters used in some tasks. WARNING: A high value may result in glitchy behaviour.
	custom_collections = {}, -- A table of tables containing names of tasks, for details read on.
	enable_counters = true, -- Enables/Disables counters in tasks that support counters.
	enable_highlights = true, --Enables/Disables highlights. Care is taken to ensure that tasks are possible without them.
	possible_marks_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" }, -- A list of possible marks.
	possible_register_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" }, -- A list of possible registers.
	task_alphabet = "ABCDEFGabddefg,.", -- The alphabet of targets used in tasks like f,t etc.
    --Even more options are available, see the Readme for all the details
})
```
I would like to focus on these of the in particular:
## enable_counters

This is used in tasks like "d[counter]w". While certainly usefull,
I would suggest disabling the counter at the beginning. This removes
keypresses from the sequence and decreases cognitive load.
This can be done this way(Multiple calls to configure will simply override the previous ones):

```lua
local training = require("nvim-training")
training.configure({
	enable_counters= false
})
```
