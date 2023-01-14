# shrtcts Configuration

This repository defines my current configuration for the [shrtcts](https://github.com/gadenbuie/shrtcts) R package.

The `shrtcts.R` file contains the actual shortcuts that the `shrtcts` package is scanning for execution.
To keep this file structured most of the functionality is moved to the `shrtcts_helpers.R` file.

Note that the `shrtcts` package [does not run the remaining configuration script](https://github.com/gadenbuie/shrtcts/issues/23) when executing shortcuts.
All shortcuts must work independently of the file context. 
In particular, they cannot leverage local functions, variables or libraries that are defined outside the shortcut function itself.

For that reason, the `shrtcts_helpers.R` is repeatedly loaded within each shortcut.
In addition, the *absolute* path must be used to `source()` the script such that the shortcuts work correctly across projects.
