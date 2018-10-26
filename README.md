# Tasktracker

An app that lets users manage tasks.

I decided that manager assignment works as follows:
1. If a user has no manager, they and they alone can assign themselves a manager
2. If a user has a manager, they may be unassigned by the user themselves, or the assigned manager, and they may be reassigned by the user to anyone else, and by the assigned manager to anyone they manage

Note that the manager-user graph is not necessarily acyclic.
