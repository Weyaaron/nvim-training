# nvim_training

[![License: GPL](https://img.shields.io/badge/License-GPL-brightgreen.svg)](https://opensource.org/license/gpl-3-0/)


This code implements a Neovim Plugin for training your muscle memory.

This plugin fills a gap I have noticed a during interaction with vim:
Knowing is half the battle, executing another entirely.
This plugin aims to help with the latter.

A training session consists of a series of tasks, each of which is small and composable.
The plugin will recognize when a task is completed and automatically start the next one.
This helps to work on a lot of tasks in a short amount of time.

As of 2023-07, this code implements a few basic commands for training of movement.
But it is missing critical features for usability: There is little documentation, and some glitches are to be expected.
There is no guarantee that any particular version will be stable all the time.

It is loosely inspired by https://first20hours.github.io/keyzen-colemak/

# Goals 
- Ease of use. Starting a session should be seamless. The UI should not get in the way.
- Fast and flow-inducing. There should be no waiting time between tasks and as little friction between tasks as possible.
- (Eventually) Community-driven. Adding new tasks is encouraged, both by providing the interfaces and the documentation required.
- Customizable. Task should be switched on and off with ease and the difficulty should be adjustable.

# Non-Goals
- Implement puzzles. A solution to the current task should be obvious and small, at most a few keystrokes on a vanilla setup.
- Competing with others. Your progress matters to you, not to others. 
- Provide help/guides on how to solve a particular task. Basic familiarity with vim is assumed.
- Constrain the user on how to solve a particular task

# Roadmap (As of 2023-07)
- Implement and release tasks that involve changes to the buffer 
- Add a config function to allow users to filter the tasks
- Write a huge chunk of documentation, in particular for the task interface
- Start using releases to mark stable versions
- Implement some sort of progress during a session

## To try it out

As of 2023-07, the version marked as main does support all the currently implemented tasks yet.
Furthermore, the startup is a bit messy. 
Patience is advised, the pool of tasks will be expanded and the startup cleaned up.

- Install it using the plugin manager of your choice. Packer is tested, if any other fails, please open an issue.
- Run `:Training` to start a session.

## [License](/LICENSE)
[GPL](LICENSE)