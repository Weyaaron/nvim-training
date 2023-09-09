This document aims to give a broad overview of the code base. 
Most of the code is written in Object-Oriented Style, unless otherwise noted.
While I have some experience with software development, I am new to Lua.
Any feedback on best practices/obvious errors is welcome. 

## The Architecture
Most of the task logic is run based on autocmds. There is a "main loop" that runs with each autocmd and does the 
following:
- Check for task completion
- Update the currently active task if required
- Update the various states including level and round
- Update the UI
- Disable the old autocmds and enable the new ones

The class TaskSequence is the top-level class. It manages the classes level and round respectively.
The task sequence starts with choosing new tasks from a pool at random. These tasks will be done
in order until a round has been finished. A this point the pool will be refreshed. 

## The Task
This is the main object this codebase revolves around. The parent class implements the interface in such 
a way that children require minimal code.

A particular task has a lifecycle implemented by setup, completed or failed, and teardown respectively.
Setup is called once when the task after the task is considered active. Completed and failed are called to check for 
completion or failure. 
Teardown is called once when the task is no longer active.
Tasks may fail or complete or do neither. Doing both is not allowed, but this is not enforced.
Doing neither is fine, but there should be a good reason for it.
Currently, Tasks should be completed or failed on the first attempt. 

To ease access to content that may be reused between tasks, a task may load additional data from json during
setup. This is somewhat of an advanced feature and is not required for getting started.

Apart from the methods, there are a few critical attributes: 
- autocmds: This list contains strings representing autocmds from the vim api. All of these will be used to check for completion or failure.
- tags: These are short strings that can be used to filter tasks. Support for these is currently patchy, inclusion is welcomend but not required.
- desc: This is string is used in the UI to display the goal of the task. Changing it during setup is encouraged.
- help: If you want to provide optional hints to the users, add it in here.
- min_level: The minimal level of a task. Starting out with a value in the range 5+ is probably a good start, this is subject to discussion during the pr.

Dependencies between tasks are discouraged. Each task is responsible for 
altering the environment to ensure that the user is able to complete the task. Cleaning 
up after a task is not required, but encouraged.
In particular, avoid moving the cursor if not required. This messes with the perception of the user.