# nvim-training

[![License: GPL](https://img.shields.io/badge/License-GPL-brightgreen.svg)](https://opensource.org/license/gpl-3-0/)

This code implements a Neovim Plugin for training your muscle memory.

This plugin fills a gap I have noticed during interaction with vim:
Knowing is half the battle, executing another entirely.
This plugin aims to help with the latter. Basic familiarity
with vim is assumed.

A training session consists of a series of tasks, each of which is small and easily repeatable.
The plugin will recognize when a task is completed and automatically start the next one.
This helps to work on a lot of tasks in a short amount of time.

I consider this project mature enough for daily use. I will expand it as I see fit, which
might include months of inactivity. I will respond to issues quickly, including
requests for new features.

I will attempt to ship breaking changes to public interfaces in such a way that they are done "all/many at once".
I consider this to be the best option for minimizing disruptions. 

# Some stats of current tasks

- Supported Tasks: 54
- Supported Tasks-Collections: 5
- Supported Schedulers: 3

Some of the tags are currently inconsistent, this is under way to be fixed.

# In Action
![GIF](media/screencast.gif)

# Installation

Install it using the plugin manager of your choice.
[Lazy](https://github.com/folke/lazy.nvim) is tested,
if any other fails, please open an issue. Pinning your local installation to a fixed version is encouraged.
In Lazy, a possible setup might be:

```lua
local lazy = require("lazy")
local plugin_list = {
    -- Your various other plugins ..
    {"https://github.com/Weyaaron/nvim-training", pin= true, opts = {}} 
    -- Support for configuration with opts is included, see below for the options
}
lazy.setup(plugin_list)
```

# Commands
This plugin uses subcommands of `Training` to activate certain functions.
All of these commands support completion, just use `Tab` and you will be fine.
Currently, these are the available options:

| Name | Syntax | Description |
| --- | -------- | -------- |
| Start | `:Training Start [Scheduler] [Task-Collection A] [Task Collection B] ...`| Starts a session with the choosen scheduler and the choosen task collections. Both arguments are optional. |
| Stop | `:Training Stop`| Stops a session. |
| Analyze | `:Training Analyze`| Prints some statistics about your progress. |

Some care is taken to avoid overwritting your files, but just to be
safe you may start in an empty buffer/directory.


<!-- s -->
# All tasks
| Name | Description | Tags | Notes
| --- | -------- | -------- | -------- |
|AppendChar | Insert a char next to the cursor. | append, insertion, change |
|BlockCommentLine | Change the current line into a block comment. | change, plugin, programming, comment | This assumes the use of a plugin, it is not tested with the buildin-commenting-feature. |
|ChangeWord | Change multiple words. | c, horizontal, w, word, change |
|CommentLine | Change the current line into a single line comment. | change, commenting, plugin, programming | Not available in vanilla-vim, needs plugin. |
|DeleteChar | Delete the current char. | change, char, deletion |
|DeleteF | Delete with the F-motion. | F, horizontal, deletion |
|Deletef | Delete with the motion f. | f, horizontal, deletion |
|DeleteInsideMatch | Delete inside the current match. | inside, match, deletion |
|DeleteLine | Delete the current line. | change, line, deletion |
|DeleteSentence | Delete the textobject inner sentence. | sentence, deletion |
|Deletet | Delete with the motion t. | horizontal, t, deletion |
|DeleteT | Delete with the movement T. | T, horizontal, movement |
|DeleteWORD | Delete multiple WORDs. |  WORD, deletion |
|DeleteWord | Delete multiple words. |  word, deletion |
|Increment | Increment the value at the cursor. | change, char, increment |
|InsertChar | Insert a char at the current position. | char, insertion, change |
|JoinLines | Join the current line with the line below. | J, join, line, change |
|MoveAbsoluteLine | Move to the absolute line. | line, vertical, movement |
|MoveCharsLeft | Move left charwise. | char, h, horizontal, movement |
|MoveCharsRight | Move right charwise. | horizontal, l, movement |
|MoveEndOfFile | Move to the end the file. | end, file, vertical, movement |
|MoveEndOfLine | Move to the end of the current line. | end, horizontal, line, movement |
|Movef | Find the next char. | horizontal, f, movement |
|MoveF | Go back to the last ocurrence of a char. | F, horizontal, movement |
|MoveLinesDown | Move down multiple lines. | horizontal, k, lines, movement |
|MoveLinesUp | Move multiple lines up. | horizontal, k, lines, movement |
|MoveMatch | Move to the current match. | movement, match |
|Moveo | Enter and leave insert mode below the current line. | insert_mode, linewise, movement, o |
|MoveO | Enter and leave insert mode above the current line. | insert_mode, linewise, movement, O |
|MoveStartOfFile | Move to the start of the file. | file, vertical, start |
|MoveStartOfLine | Move to the start of the current line. | line, movement, start |
|MoveT | Go back next to the last ocurrence of a char. | horizontal, left, T, movement |
|Movet | Move using t. | horizontal, t, movement |
|MoveWORD | Move multiple WORDS. | W, WORD, movement |
|MoveWord | Move multiple words. | horizontal, w, word, movement |
|MoveWordEnd | Move to the end of words. | end, vertical, word, movement |
|MoveWORDEnd | Move to the end of WORDs. | end, vertical, word, movement |
|MoveWORDStart | Move Back to the start of 'WORDS'. | horizontal, word, movement |
|MoveWordStart | Move back to the start of 'words'. | horizontal, word, movement |
|Paste | Paste from a given register. | register, Paste |
|paste | Paste from a given register. | register, paste |
|SearchBackward | Search backwards. | diagonal, movement, search |
|SearchForward | Search forwards. | forward, movement, search |
|SearchWordBackward | Search backwards for the word at the cursor. | backward, movement, search |
|SearchWordForward | Search forwards for the word at the cursor. | forward, movement, search |
|YankEndOfLine | Yank to the end of the current line. | line, yank, end |
|Yankf | Yank to the next char. | , f, horizontal, yank |
|YankF | Yank back to the previous char. | , F, horizontal, yank |
|YankInsideMatch | Yank inside the current match. | inside, match, yank |
|YankIntoRegister | Yank a line into a register. | copy, line, vertical, register |
|YankT | Yank back next to the previous char. | T, horizontal, yank |
|Yankt | Yank to the next char. | , f, horizontal, yank |
|YankWORD | Yank multiple WORDS. | counter, horizontal, w, word, yank |
|YankWord | Yank multiple words. | counter, horizontal, w, word, yank |
<!-- e -->

# Task-Collections

The following table lists the available collections. Support for custom collections is
included and described below.

| Name | Description | Link
| ----------- | -------- | -------- |
| All | All supported tasks. Does involve tasks that are designed with plugins in mind!| [All](/docs/collections/All.md)
| Change | Tasks involving some change to the buffer.| [Change](/docs/collections/Change.md)
| Movements | Tasks involving movement.| [Movements](/docs/collections/Movements.md)
| NonMovements | Tasks not involving movement.| [NonMovements](/docs/collections/NonMovements.md)
| Yanking | Tasks involving yanking| [Yanking](/docs/collections/Yanking.md)

# Schedulers

| Name | Description | Supported Arguments |
| ----------- | -------- | ---- |
| RandomScheduler | The next task is chosen at random. | - |
| RepeatUntilNSuccessScheduler | The current task is repeated until n successes are reached. | repetitions|
| RepeatNScheduler | A task is repeated n-times. | repetitions |

# Configuration
A interface for configuration is provided. These are the default values if you do not change
anything yourself.
```lua
local training = require("nvim-training")
training.configure({ -- All of these options work for 'opts' of lazy as well.
	audio_feedback = true, -- Enables/Disables audio feedback, if enabled, requires the 'sox' package providing the 'play' command.
	base_path = vim.fn.stdpath("data") .. "/nvim-training/", -- The path used to store events.
	counter_bounds = { 1, 5 }, --The outer bounds for counters used in some tasks. WARNING: A high value may result in glitchy behaviour.
	custom_collections = {}, -- A table of tables containing names of tasks, for details read on.
	enable_counters = true, -- Enables/Disables counters in tasks that support counters.
	enable_events = true, -- Enables/Disables events.
	enable_highlights = true, --Enables/Disables highlights. Care is taken to ensure that tasks are possible without them.
	logging_args = {
		log_path = vim.fn.stdpath("log") .. "/nvim-training/" .. os.date("%Y-%M-%d") .. ".log",
		display_logs = false, --Enables/Disables wether messages with the level 'log' should be printed. WARNING: Enabling his produces a lot of noise, but might be usefull for developers.
		display_warnings = true, --Enables/Disables wether messages with the level 'warning' should be printed.
		skip_all = false, -- Enables/Disables logging entirely. Usefull if you are worried about saving disk space.
	},
	possible_marks_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" }, -- A list of possible marks.
	possible_register_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" }, -- A list of possible registers.
	scheduler_args = { repetitions = 5 }, --These args are used to configure all the available schedulers
	task_alphabet = "ABCDEFGabddefg,.", -- The alphabet of targets used in tasks like f,t etc.
})
```

## Custom Collections
To add a custom collection, please use its name as a key for a list of task names in the config, for example like this:

```lua
local training = require("nvim-training")
training.configure({
    -- .. your other configs ...
	custom_collections = { MyCollection = { "MoveWord", "MoveWORD"}}
})
```
You may provide as many collections as you wish, they will be available in autocompletion.

# Goals
- Ease of use. Starting a session should be seamless. The UI should not get in the way.
- Fast and flow-inducing. There should be no waiting time/friction between tasks. 
- (Eventually) Community-driven. Adding new tasks is encouraged, both by providing the interfaces and the documentation required.
- Customizable. Task should be switched on and off with ease, and the difficulty should be adjustable.

# Non-Goals
- Implement puzzles. A solution to the current task should be obvious and small, at most a few keystrokes on a vanilla setup.
- Competing with others. Your progress matters to you, not to others.
- Provide help/guides on how to solve a particular task. Basic familiarity with vim is assumed.
- Constrain the user on how to solve a particular task.
- Support for everyones personal setup. Some settings may mess up some tasks, support for these cases is limited. I try to accomodate about 80% of the users and 
will decide each upcoming case on its own.

# On Contributions
Contributions are welcome! Any input is appreciated, be it a bug report, a feature request, or a pull request.
Just open a issue and we shall get cooking :)

# [License](/LICENSE)
[GPL](LICENSE)
