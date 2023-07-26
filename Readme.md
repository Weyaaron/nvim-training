# nvim_training

[![License: GPL](https://img.shields.io/badge/License-GPL-brightgreen.svg)](https://opensource.org/license/gpl-3-0/)


This code implements a Neovim Plugin for training your Muscle Memory.

This plugin fills a gap I have noticed a during interaction with vim:
Knowing is half the battle, executing another entirely.
This plugin aims to help with the latter.

A training session consists of a series of tasks, each of which is small and composable.
The plugin will recognize when a task is completed and automatically start the next one.
This helps to work on a lot of tasks in a short amount of time.

As of 2023-07, this code implements a few basic commands for training but is missing 
critical features for usability. In particular, it is not installable yet and huge 
portions of the documentation is missing. There is no guarantee that any particular 
version will be stable all the time. 


# Goals 
- Ease of use. Starting a session should be seamless. The UI should not get in the way.
- Fast and flow-inducing. There should be no waiting time between tasks and as little friction between tasks as possible.
- Community-driven. Adding new tasks is encouraged, both by providing the interfaces and the documentation required.
- Customizable. Task should be switched on and off with ease and the difficulty should be adjustable.

# Non-Goals
- Implement puzzles. A solution to the current task should be obvious and small, at most a few keystrokes on a vanilla setup.
- Competing with others. Your progress matters to you, not to others. 
- Provide help/guides on how to solve a particular task. Basic familiarity with vim is assumed.
- Constrain the user on how to solve a particular task

It is loosely inspired by https://first20hours.github.io/keyzen-colemak/

## To try it out

As of 2023-07, this does not support all the currently implemented tasks yet. This is 
the most basic version suited for public use. 
Please use on your own risk.

1. Clone this repository
2. Ensure the luarock module "lua-cjson" is installed
3. Open Neovim inside the repository
4. Run `:source plugin/training.lua`

## [License](/LICENSE)
[GPL](LICENSE)