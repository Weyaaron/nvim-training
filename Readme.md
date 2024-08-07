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
    {"https://github.com/Weyaaron/nvim-training", pin= true}
}
lazy.setup(plugin_list)
```

# Starting a Session
Two settings influence the current session:

The scheduler and the list
of task collections. The scheduler is responsible for choosing the
next task. The possible choices are listed below.
A task collection is a set of tasks with some common attributes,
some examples are given below. Support for custom collections
is under way.

`:Training [Scheduler] [Task-Collection A] [Task Collection B] ...`

After autocompletion, a call might look like:

`:Training RandomScheduler All`

Both arguments 'Scheduler' and all 'Task-Collection's are optional, if not provided a default value will be used.

Some care is taken to avoid overwritting your files, but just to be
safe you may start in an empty buffer/directory.

## Currently supported tasks
| Name | Description | Tags | Notes
| --- | -------- | -------- | -------- |
|AppendChar | Insert a char next to the cursor. |  append,  insertion, change |
|CommentLine | Change the current line into a single line comment. |  change,  commenting,  plugin, programming | Not available in vanilla-vim, needs plugin. |
|DeleteChar | Delete the current char. |  change,  char, deletion |
|DeleteInsideMatch | Delete inside the current bracket pair. |  change,  inside,  match, deletion |
|DeleteLine | Delete the current line. |  change,  line, deletion |
|Increment | Increment the value at the cursor. |  change,  char, increment |
|InsertChar | Insert a char at the current position. |  char,  insertion, change |
|MoveAbsoluteLine | Move to the absolute line. |  line,  vertical, movement |
|MoveEndOfFile | Move to the end the file. |  end,  file,  vertical, movement |
|MoveEndOfLine | Move to the end of the current line. |  end,  horizontal,  line, movement |
|MoveF | Move using F. |  F,  horizontal, movement |
|MoveMatch | Move to the current match. |  movement, match |
|MoveRandom | Move to the random target. |  diagonal,  movement, plugin | This task assumes the existence of a plugin that provides such a motion. |
|MoveStartOfFile | Move to the start of the file. |  file,  vertical, start |
|MoveStartOfLine | Move to the start of the current line. |  line,  movement, start |
|MoveT | Move using T. |  T,  horizontal, movement |
|MoveWORD | Move using W. |  W,  WORD, movement |
|MoveWord | Move using w. |  horizontal,  w,  word, movement |
|MoveWordEnd | Move to the end of the current 'word'. |  end,  vertical,  word, movement |
|MoveWordStart | Move to the start of the current 'word'. |  horizontal,  word, movement |
|Movef | Move using f. |  f,  horizontal, movement |
|Movet | Move using t. |  horizontal,  t, movement |
|Paste | Paste from a given register. |  register, paste |
|SearchForward | Search forwards for a target-string. |  diagonal,  movement, search |
|YankEndOfLine | Yank to the end of the current line. |  line,  yank, end |
|YankInsideMatch | Yank inside the current match. |  inside,  match, yank |
|YankIntoRegister | Yank a line into a register. |  copy,  line,  vertical, register |

# Task-Collections

The following table lists the available collections. They will grow over
time and support for your own custom collections is on the roadmap.

| Name | Description | Link
| ----------- | -------- | -------- |
| All  | All supported tasks. Does involve tasks that are designed with plugins in mind!| [All](/docs/collections/All.md)
| Change  | Tasks involving some change to the buffer.| [Change](/docs/collections/Change.md)
| Movements  | Tasks involving movement.| [Movements](/docs/collections/Movements.md)
| NonMovements  | Tasks not involving movement.| [NonMovements](/docs/collections/NonMovements.md)
| Yanking  | Tasks involving yanking| [Yanking](/docs/collections/Yanking.md)


# Schedulers

| Name | Description |
| ----------- | -------- |
| RandomScheduler | The next task is chosen at random. |
| RepeatUntilNSuccess | The current task is repeated until n successes are reached. |

# Configuration
A interface for configuration is provided. A example call is provided:
```lua
local training = require("nvim-training")
training.configure({
	possible_marks_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" }, --A list of possible marks. (Optional, this is the default)
	possible_register_list = { "a", "b", "c", "r", "s", "t", "d", "n", "e" }, -- A list of possible registers. (Optional, this the default)
	audio_feedback = true, --Enables/Disables audio feedback, if enabled, requires the 'sox' package providing the 'play' command.
})
```

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
- Support for everyones personal setup. Some settings may mess up some tasks, support for these cases is limited. I try to accomodate about 80% of the users.

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
