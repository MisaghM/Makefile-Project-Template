
# Makefile Project Template

- [Makefile Project Template](#makefile-project-template)
  - [About](#about)
  - [How-To](#how-to)
  - [Folder Hierarchy](#folder-hierarchy)
  - [.vscode](#vscode)
  - [Windows](#windows)
  - [License](#license)

## About

A GNU Makefile template with [auto dependencies](https://make.mad-scientist.net/papers/advanced-auto-dependency-generation).  
(Makes dependency files alongside object files, and uses them as prerequisites to only rebuild changed files)

## How-To

Put all source files in `PATH_SRC` (the `src` folder by default)  
You can put libraries in `PATH_LIB` and set the `LDLIBS`.  
That's it.  
  
Use `make help` to see all the available targets.  
There are some targets for cleanup (`clean` `clean-obj` `clean-dep` `clean-exe` `delete-build`)  
And a target to run the program (`make run ARGS="arg1 arg2..."`)  

*Source file names are put in `FILES` automatically (all `.cpp` files in `PATH_SRC`)*  
*if you want to write them manually, don't prefix `$(PATH_SRC)/` for the items and don't forget to put nested `PATH_SRC` folders in the `FOLDERS` variable.*

## Folder Hierarchy

By default:

```text
- build
   - bin
   - obj
     - dep
- lib
- src
Makefile
```

## .vscode

Optional for VSCode.  
This folder contains a sample `launch.json` and `tasks.json` required for building in VSCode.  
The build task is simply running the `make` command. Launching (F5) does this as the `preBuildTask` and runs the program in gdb (and skips the `std::` namespace for easier debugging).

## Windows

It is highly recommended to use a Bash-like environment (with tools such as [MSYS](https://www.msys2.org/)) to make the best of Makefiles on Windows.  
Trying to only use MinGW with CMD may lead to many problems.

<details><summary>No Bash: (click to expand)</summary>

For the **Makefile** to work without Bash, some changes need to be made:
  
- The Unix commands need to be replaced with DOS ones.

  In common_vars.mk:

  ```makefile
  ifeq ($(OS),Windows_NT)
    MKDIR  = mkdir
    RM     = del
    RMDIR  = rmdir /S /Q
    COPY   = copy
    MOVE   = move
    RENAME = ren
    NULL_DEVICE = nul
  else
    MKDIR  = mkdir -p
    RM     = rm -f
    RMDIR  = rm -rf
    COPY   = cp
    MOVE   = mv -f
    RENAME = mv -f
    NULL_DEVICE = /dev/null
  endif
  ```

- In the Makefile, unix slashes (`/`) have to be changed to backslashes (`\`)

  These ones in particular:

  - Line 4, 5, 6.
  - Line 34.
  - Line 48, 55, 56.
  - Line 65, 66, 67.
  - Line 71.
  
- The [postcompile](http://make.mad-scientist.net/papers/advanced-auto-dependency-generation/#unusual) step requires the `touch` command which is not available on Windows.

  You can either remove the postcompile step:  
  [Remove lines 34 and 39, and change `.dTMP` at the end of line 33 to `.d`]  
  *Or* get a `touch` command [equivalent](https://stackoverflow.com/a/30019017). (the touch command makes a file if it doesn't exist, and sets the last modified date to now if it does)  
  *Alternatively*, since only the last modified date change is used for the postcompile step, you can just change `touch $@` (line 34) to the dos command `copy /b $@ +,,`

- To automatically find source files, the `FILES` and `FOLDERS` (lines 20 and 21) have to be changed because they use the `find` command not available on Windows:

  ```makefile
  FILES   = $(subst $(subst /,\,$(CURDIR))\src\,,$(shell dir /B /S /A-D $(PATH_SRC)\*.cpp))
  FOLDERS = $(subst $(subst /,\,$(CURDIR))\src\,,$(shell dir /B /S /A:D $(PATH_SRC)))
  # Alternatively:
  # FILES   = $(foreach F, $(shell dir /B /S /A-D $(PATH_SRC)\*.cpp), $(lastword $(subst \src\, ,$F)))
  # FOLDERS = $(foreach F, $(shell dir /B /S /A:D $(PATH_SRC)), $(lastword $(subst \src\, ,$F)))
  ```

- The `\*` at the end of lines 65 and 66 should also be removed.

And for **vscode**, since the `make` executable is named `mingw32-make` in MinGW, you should make the change in `tasks.json`.  
*Or* you can create a symbolic link of the executable (`mklink make.exe mingw32-make.exe`) or a `make.bat` file with the following content in your environment path:  

```bat
mingw32-make %*
```

</details>

## License

[![license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/MisaghM/Makefile-Project-Template/blob/main/LICENSE "Repository License")
