# nvim_training

[![License: GPL](https://img.shields.io/badge/License-GPL-brightgreen.svg)](https://opensource.org/license/gpl-3-0/)

# About the current rewrite
The repository is currently in an unstable stage, I am doing a rewrite.
Please be patient, I work irregularly on this.
In particular, installation currently does not work as intented.



This code implements a Neovim Plugin for training your muscle memory.

This plugin fills a gap I have noticed during interaction with vim:
Knowing is half the battle, executing another entirely.
This plugin aims to help with the latter.

A training session consists of a series of tasks, each of which is small and easily repeatable.
The plugin will recognize when a task is completed and automatically start the next one.
This helps to work on a lot of tasks in a short amount of time.

As of 2024-03, the current version implemens a couple of tasks.
A lot more are under way.

This is my first second in this particular domain, it is actually a
rewrite from a previous attempt at this particular problem. The first
one had a atrocious code-base, I hope this one will work out better  ;)

# In Action
![GIF](media/screencast.gif)

# To try it out

- Install it using the plugin manager of your choice. [Lazy](https://github.com/folke/lazy.nvim) is tested, if any other fails, please open an issue. Pinning it to a fixed version is encouraged.

- Run the setup in your lua-config:
lua`
local training_module = require("nvim-training")
training_module.setup({})
`
- Make sure you are in an empty buffer.
- Run `:Training` to start a session.


--Todo:  Configure a  proper preview


# Available tasks

| Name | Description | File-Link |
| -------- | -------- | -------- |
| MoveToEndOfLine     | Move the cursor to the end of the Line. | [File](./lua/nvim-training/tasks/move_to_end_of_line.lua)
| MoveToStartOfLine     | Move the cursor to the start of the Line. | [File](./lua/nvim-training/tasks/move_to_start_of_line.lua)

# Some tasks currently in the pipeline


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


# Roadmap (As of 2024-03)
TODO After rewrite is done

# [License](/LICENSE)
[GPL](LICENSE)
