
# Makefile Project Template

- [Makefile Project Template](#makefile-project-template)
  - [About](#about)
  - [How-To](#how-to)
  - [Folder Hierarchy](#folder-hierarchy)
  - [.vscode](#vscode)
  - [For Windows (MinGW)](#for-windows-mingw)
  - [License](#license)

## About

A GNU Makefile template with [auto dependencies](https://make.mad-scientist.net/papers/advanced-auto-dependency-generation).  
(Makes dependency files alongside object files, and uses them as prerequisites to only rebuild changed files)

## How-To

Put all source files in `PATH_SRC` (the `src` folder by default)  
Write source file names in `FILES` (set more `VPATH` if you want)  
You can also put libraries in `PATH_LIB` and set the `LDLIBS`.  
That's it.

## Folder Hierarchy

By default:

```text
- build
   - bin
   - obj
     - dep
- lib
- src
```

## .vscode

Optional for VSCode.  
This folder contains a sample `launch.json` and `tasks.json` required for building in VSCode.  
The build task is simply running the `make` command, and the launch (F5) does this as the `preBuildTask` and runs the program in gdb (and skips the `std::` namespace for easier debugging).

## For Windows (MinGW)

For the **Makefile** to work on Windows, some minor changes need to be made:

- If using CMD, these unix slashes (`/`) have to be changed to backslashes (`\`):

  - Line 4, 5, 6.
  - Line 31, 32.
  - Line 53, 54, 55.
  - Line 59.
  
- The [postcompile](http://make.mad-scientist.net/papers/advanced-auto-dependency-generation/#unusual) step requires the `touch` command which is not available on Windows.

    You can either remove the postcompile step:  
    [Remove lines 32 and 37, and change `.dTMP` at the end of line 31 to `.d`]  
    *Or* get a `touch` command [equivalent](https://stackoverflow.com/a/30019017). (make file if it doesn't exist, and set the last modified date to now if it does)  
    *Alternatively*, since only the last modified date change is used for the postcompile step, you can just change `touch $@` (line 32) to `copy /b $@ +,,`

And for **vscode**, since the `make` executable is named `mingw32-make` in MinGW, you should make the change in `tasks.json`.  
*Or* you can create a `make.bat` file with the following content:  

```bat
mingw32-make %*
```

## License

[![license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/MisaghM/Makefile-Project-Template/blob/main/LICENSE "Repository License")
