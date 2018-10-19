# Tasktracker

An app that lets users manage tasks.

The main design dilemma I faced was the database structure. I decided on having a users and a tasks table. A user just has a name. A task has a title, a desc, a completed flag, an assigned user, and time spent. I decided to make the assigned user a foreign key in the task table. This caused its own problems, because before a user was assigned to a task, there was no default option I could use, so I had to create a hidden dummy account. I decided to keep an Accounts page, which is read-only for all other users but the logged in one, and the only option is for a user to delete their own account. This also clears the user from an tasks assigned to them, and clears the time. It provides a reference for assigning tasks. It isn't obvious by looking, but a user can only fill in the time for tasks to whcih they are assigned, but anyone can mark tasks as complete or not, or delete or edit them.
