### Ansible handlers can possibly be used to create a migration system.
1. Gather a fact from the remote system, which is the build number of a file on that system.
2. Create a build handler (builder) for every build upgrade with a change requiring migrations (moving files and directories).
3. Every role will then have each builder in a handlers directory.
4. The handler in every build sets the config value for it's role in a config file on the remote system.
5. The handlers should check if the role is marked with it's previous build number and run if it is.
6. The handlers should either be specified in the task:
  - In incrementing order, so that each version is executed in order.
  - In decrementing order and each builder has the next handler in it's handler.

### Categorize config files
- In my home directory have a folder with categories of config files
- Have a symlink to the right config files put in the different categories
- The same config file can be in multiple categories
