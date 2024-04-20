# nvim-training

[![License: GPL](https://img.shields.io/badge/License-GPL-brightgreen.svg)](https://opensource.org/license/gpl-3-0/)

This code implements a Neovim Plugin for training your muscle memory.

This plugin fills a gap I have noticed during interaction with vim:
Knowing is half the battle, executing another entirely.
This plugin aims to help with the latter.

A training session consists of a series of tasks, each of which is small and easily repeatable.
The plugin will recognize when a task is completed and automatically start the next one.
This helps to work on a lot of tasks in a short amount of time.

As of 2024-03, the current version implemens a couple of tasks.
A lot more are under way.

# In Action
![GIF](media/screencast.gif)

# Installation

Install it using the plugin manager of your choice.
[Lazy](https://github.com/folke/lazy.nvim) is tested, if any other fails, please open an issue. Pinning your local installation to a fixed version is encouraged.

# Mandatory Setup
The setup is actually mandatory, the plugin wont start without it. This ensures that you train with tasks that feel productive to you.
The lines below are sufficient to get started, and there are a few more examples sprinkled throughout the document.
Simply place them in your init.lua:

```lua
local training = require("nvim-training")
training.setup({
	task_list = { "MoveEndOfLine", "MoveStartOfLine" }, -- This is a list of strings that will be resolved to the actual tasks
	task_scheduler = "RandomScheduler",  -- The default scheduler will pick a new tasks at random from the provided list.
})
```
This document lists all the other available options for each
of the keys, see below.

# Starting a Session
Once the setup has been done, simply run `:Training` to start a session.
Some care is taken to avoid overwritting your files, but just to be
safe you may start in an empty buffer/directory.

# Available tasks

## Movements
| Name | Description | Notes |
| -------- | -------- | -------- |
| MoveEndOfLine   | Move the cursor to the end of the line. |
| MoveStartOfLine | Move the cursor to the start of the line. |
| MoveStartOfFile | Move the cursor to the start of the file. |
| MoveEndOfFile | Move the cursor to the end of the file. |


## Searching
| Name | Description | Notes |
| -------- | -------- | -------- |
| SearchForward| Search for target-string forwards. |

## Text Manipulation
| Name | Description | Notes |
| -------- | -------- | -------- |
| YankEndOfLine| Copy text from the cursor to the end of the line. |
| YankIntoRegister| Copy text into a specified register. |
| YankWord| Copy the highlighted word. |

## Miscelaneous

| Name | Description | Notes |
| -------- | -------- | -------- |
| Increment | Increment/Decrement the value under the cursor.| Does not include values like dates, booleans, just numbers


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
		"YankIntoRegister",
		"YankWord",
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
- Constrain the user on how to solve a particular task

# How to get started with contributing
Contributions are welcome! Any input is appreciated, be it a bug report, a feature request, or a pull request.
This is my first project in lua, therefore, some junk and bad practices are to be expected. Any feedback/suggestions
are welcome.

First of all, you should have a look at the issues. Maybe someone else has already raised your concern.
If you want to start working on something, please open an issue first. This helps to avoid duplicate work and to get feedback early on.


# [License](/LICENSE)
[GPL](LICENSE)
