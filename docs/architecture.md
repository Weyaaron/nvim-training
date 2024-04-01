This document aims to give a broad overview of the code base.
Most of the code is written in Object-Oriented Style, unless otherwise noted.

## The Architecture
Most of the task logic is run based on autocmds. There is a "main loop" that runs with each autocmd and does the
following:
- Checks for task completion
- Updates the UI
- Disables the old autocmds and enables the new ones

## The Task
Since the loop triggers on each autocmd-event, each Task must finish 
after one of these events. The calculation of the result and the 
cleanup happens in the methon "teardown".
Dependencies between tasks are discouraged. Each task is responsible for
altering the environment to ensure that the user is able to complete the task. Cleaning up after a task is not required, but encouraged.

## The Scheduling 
The user may choose between different modes of scheduling by running the 
setup config. Each scheduling algorithm is implemented in its own 
class. 
