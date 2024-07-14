# nvim-training

[![License: GPL](https://img.shields.io/badge/License-GPL-brightgreen.svg)](https://opensource.org/license/gpl-3-0/)

This code implements a Neovim Plugin for training your muscle memory.

This plugin fills a gap I have noticed during interaction with vim:
Knowing is half the battle, executing another entirely.
This plugin aims to help with the latter.

A training session consists of a series of tasks, each of which is small and easily repeatable.
The plugin will recognize when a task is completed and automatically start the next one.
This helps to work on a lot of tasks in a short amount of time.

The list of tasks is growing all the time, if you miss a particular one you may open a feature request :)

# About stability

This code-base may evolve to points where breaking changes will be made.
As of 07-2024, I consider the userbase small enough to 'just do' them.
This may change in the future, let me know with suggestions for best
practices :)

# For beginners

Hi, welcome. Since this plugin is aimed at beginners, I will help out with any
issues about getting started. Just message me over on aaronwey@posteo.de
and I will help you out. Depending on the issue, your feedback may be used
to improve the setup for everyone :)

# In Action
![GIF](media/screencast.gif)

# Installation

Install it using the plugin manager of your choice.
[Lazy](https://github.com/folke/lazy.nvim) is tested, if any other fails, please open an issue. Pinning your local installation to a fixed version is encouraged.
In Lazy, a possible setup might be:

```lua
local lazy = require("lazy")
local plugin_list = {
    -- Your various other plugins ..
    {"https://github.com/Weyaaron/nvim-training", pin= true}
}
lazy.setup(plugin_list)
```

# Mandatory Setup
The setup is mandatory, the plugin wont start a training session without it. This ensures that you train with tasks that feel productive to you.
The lines below are sufficient to get started.
Simply place them in your init.lua:

```lua
local training = require("nvim-training")
training.setup({
	task_list = { "MoveEndOfLine", "MoveStartOfLine" }, -- This is a list of strings that will be resolved to the actual tasks. (Mandatory)
	task_scheduler = "RandomScheduler",  -- The default scheduler will pick a new tasks at random from the provided list. (Mandatory)
	possible_marks_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" }, --A list of possible marks. (Optional, this is the default)
	possible_register_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" }, -- A list of possible registers. (Optional, this the default)
	audio_feedback = true, --Enables/Disables audio feedback
	audio_feedback_success = function() -- What actually happens when audio feedback is run. You may test this or replace it with your own function as you see fit.
		os.execute("play media/click.flac 2> /dev/null")
	end,
	audio_feedback_failure = function()
		os.execute("play media/clack.flac 2> /dev/null")
	end,

})
```

# Starting a Session
Once the setup has been done, simply run `:Training` to start a session.
Some care is taken to avoid overwritting your files, but just to be
safe you may start in an empty buffer/directory.

# Available Tasks

The following sections lists the tasks that are available.
The code may ship with many more, but their state is
unfinished. Accesing them might be possible, but
is your own risk.

# Disabled Tasks
There might be cases where tasks have to be
retracted. If this is the case, you may need
to update your call to setup to exclude them.

## Movements
| Name | Description | Notes |
| -------- | -------- | -------- |
| MoveEndOfLine   | Move the cursor to the end of the line. |
| MoveStartOfLine | Move the cursor to the start of the line. |
| MoveStartOfFile | Move the cursor to the start of the file. |
| MoveEndOfFile | Move the cursor to the end of the file. |
| MoveRandomXY | Move the cursor to a random place in the file. | This task assumes the use of a plugin that provides such a movement. |

## Searching
| Name | Description | Notes |
| -------- | -------- | -------- |
| SearchForward| Search for target-string forwards. |

## Miscelaneous

| Name | Description | Notes |
| -------- | -------- | -------- |
| Increment | Increment/Decrement the number under the cursor.|

There is an [open discussion](https://github.com/Weyaaron/nvim-training/issues/13) if tasks like this should be included.
If you have an opinion, feel free to add it.

## Programming Tasks  (Currently, all of these will be in lua, support for more languages might happen)

| Name | Description | Notes |
| -------- | -------- | -------- |
| CommentLine| Change the current line into a comment. | This assumes the use of a plugin, it is not tested with the buildin-commenting-feature.


## Example of a setup that includes all tasks
To train with all of the tasks enabled, you may use the following call to setup:

```lua
local training = require("nvim-training")
training.setup({
	task_list = {
		"MoveEndOfLine",
		"MoveStartOfLine",
		"MoveEndOfFile",
		"MoveStartOfFile",
		"SearchForward",
		"Increment",
		"YankEndOfLine",
		"YankWord",
        "CommentLine",
        "MoveRandomXY",
	},
	task_scheduler = "RandomScheduler",
})
```

# Goals
- Ease of use. Starting a session should be seamless. The UI should not get in the way.
- Fast and flow-inducing. There should be no waiting time between tasks and as little friction between tasks as possible.
- (Eventually) Community-driven. Adding new tasks is encouraged, both by providing the interfaces and the documentation required.
- Customizable. Task should be switched on and off with ease, and the difficulty should be adjustable.

# Non-Goals
- Implement puzzles. A solution to the current task should be obvious and small, at most a few keystrokes on a vanilla setup.
- Competing with others. Your progress matters to you, not to others.
- Provide help/guides on how to solve a particular task. Basic familiarity with vim is assumed.
- Constrain the user on how to solve a particular task.
- Support for everyones personal setup. Some settings may mess up some tasks, but support for these cases is limited. I try to accomodate about 80% of the users.

# How to get started with contributing
Contributions are welcome! Any input is appreciated, be it a bug report, a feature request, or a pull request.
This is my first project in lua, therefore, some junk and bad practices are to be expected. Any feedback/suggestions
are appreciated.

# Best Practices for contributing

- Please open the PR to the branch named 'dev'. This ensures that there will be some buffer between the stable main and the current
development version.
- Opening a issue first is encouraged to discuss any ideas. This helps to avoid duplicate work and to get feedback early on.
- You may have a look at [dev-setup](/docs/dev_setup.md) which describes a setup that increases productivity
in development.

# [License](/LICENSE)
[GPL](LICENSE)
