# nvim_training

[![License: GPL](https://img.shields.io/badge/License-GPL-brightgreen.svg)](https://opensource.org/license/gpl-3-0/)

This code implements a Neovim Plugin for training your muscle memory.

This plugin fills a gap I have noticed during interaction with vim:
Knowing is half the battle, executing another entirely.
This plugin aims to help with the latter.

A training session consists of a series of tasks, each of which is small and easily repeatable.
The plugin will recognize when a task is completed and automatically start the next one.
This helps to work on a lot of tasks in a short amount of time.

As of 2023-08, this code implements a few basic commands for training of movement.
But it is missing critical features for usability: There is little documentation, no config, 
and some glitches are to be expected. This is my first project in this particular domain.

It is loosely inspired by https://first20hours.github.io/keyzen-colemak/

# To try it out

As of 2023-08, the version marked as main does support all the currently implemented tasks yet.
Some tasks are still not fully stable. Development will happen on the development branch, using 
this branch for testing is as of 2023-08 discouraged.

- Install it using the plugin manager of your choice. Packer is tested, if any other fails, please open an issue. Pinning it to a fixed version is encouraged.
- Make sure you are in an empty buffer.
- Run `:Training` to start a session.

# Configuration Options
To configure this plugin, overwrite the table "vim.g.nvim_training" after loading the plugin. 
This may be done in the init.lua after loading the plugin.

The following options are available (This can be copy-pasted into your init.lua):
```lua
local config= {}
config.enable_audio_feedback = false --If true, a sound will be played when a task is completed(Caution: This is experimental and may requires additional setup) Default: false
config.excluded_tags = {} -- A list of tags. Tasks with these tags will not be included in the session. Default: empty list
config.included_tags = {} -- A list of tags. Only tasks with these tags will be included in the session(If not set, all tags will be included). Default: empty list
config.first_level = 1 -- The level a session starts at. Useful for skipping the early easy tasks.  Default: 1
config.display_info = false -- This enables help in the ui. If set, some tasks will provide a hint on how to to them. Default: false
vim.g.nvim_training = config
```

Unfortunately, the names can not be set individually,
see [here](https://neovim.io/doc/user/lua-guide.html#lua-guide-variables)
and [here](https://github.com/neovim/neovim/issues/12544) for Details.


As of 2023-08 and Version 0.2, these names are subject to change. Please check the [default_config.json](plugin/default_config.json) for the current names 
on occasion. 

# Available tasks 
- Move to an absolute line
- Move x lines relative to your cursor 
- Move to a mark 
- Move chars relative to your cursor
- The Movements e and w 
- Forward-Search

# Some tasks currently in the pipeline 
- Window Management
- Delete lines 
- Delete words 
- Moving to line and a char in the buffer

# Goals 
- Ease of use. Starting a session should be seamless. The UI should not get in the way.
- Fast and flow-inducing. There should be no waiting time between tasks and as little friction between tasks as possible.
- (Eventually) Community-driven. Adding new tasks is encouraged, both by providing the interfaces and the documentation required.
- Customizable. Task should be switched on and off with ease, and the difficulty should be adjustable.

# Non-Goals
- Implement puzzles. A solution to the current task should be obvious and small, at most a few keystrokes on a vanilla setup.
- Competing with others. Your progress matters to you, not to others. 
- Provide help/guides on how to solve a particular task. Basic familiarity with vim is assumed.
- Constrain the user on how to solve a particular task


# How to get started with contributing
Contributions are welcome! Any input is appreciated, be it a bug report, a feature request, or a pull request.
This is my first project in lua, therefore, some junk and bad practices are to be expected. Any feedback/suggestions
are welcome. 

First of all, you should have a look at the issues. Maybe someone else has already raised your concern.
If you want to start working on something, please open an issue first. This helps to avoid duplicate work and to get feedback early on.

For contributing code, you may have a look at the [architecture](docs/architecture.md) document. 

# Roadmap (As of 2023-08)
- Implement and release tasks that involve changes to the buffer
- Improve the progress-communication during a session
- Improvements to the UI
- Implement and document a config


# [License](/LICENSE)
[GPL](LICENSE)