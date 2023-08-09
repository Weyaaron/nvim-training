This document aims to give a broad overview of the code base. 
Most of the code is written in Object-Oriented Style, unless otherwise noted.

## The Architecture
Most of the task logic is run based on autocmds. The main loop runs with each autocmd and does the 
following:
- Check for task completion
- Update the currently active task if required
- Update the UI
- Disable the old autocmds and enable the new ones if required 

The task queue is managed by the class TaskSequence. As of version 0.2, the task sequence 
starts with choosing new tasks from a pool at random. After this initial phase, the task sequence 
will advance the task queue based on the completion or failure of the current task.


## The Task
This is the main object this codebase revolves around. The parent class implements the interface in such 
a way that children require minimal code. As of version 0.2, there are no inheritance chains, but this may 
change. 

A particular task has a lifecycle implemented by prepare, completed or failed, and teardown respectively.
Prepare is called once when the task is first added to the task sequence. Completed and failed are called to check for 
completion or failure. 
Teardown is called once when the task is removed from the task sequence.
Tasks may fail or complete or do neither. Doing both is not allowed, but this is not enforced consistently.
Doing neither is fine, but there should be a good reason for it.


To ease access to content that may be reused between tasks, a task may load additional data from json during
prepare. This is somewhat of an advanced feature and is not required for getting started.

Apart from the methods, there are a few critical attributes: 
- autocmds: This list should contains strings representing autocmds from the vim api. All of these will be used to check for completion or failure.
- tags: These are short strings that can be used to filter tasks. A list is available in the Readme.
- desc: This is string is used in the UI to display the goal of the task. Changing it during prepare is encouraged.

Dependencies between tasks are discouraged. Each task is responsible for 
altering the environment to ensure that the user is able to complete the task. Cleaning 
up after a task is not required, but encouraged.