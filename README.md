# Enhanced `cd` Command with Directory Navigation

This script provides an improved version of the traditional `cd` command in bash by integrating additional options and an interactive directory selector powered by [fzf](https://github.com/junegunn/fzf).

## Key Features

* **Extended Options**:
  The custom `cd` function supports several flags:

  * `-L`, `-P`, `-e`, `-@` → placeholders for compatibility with `cd` behavior.
  * `-r` → triggers the interactive recursive navigation (`cdr`).

* **Interactive Directory Selection (`cdr`)**:
  When invoked with `cd -r`, the script launches a loop that:

  1. Lists all directories in the current path (including hidden ones).
  2. Displays them through `fzf` with a header showing the current working directory.
  3. Lets the user move step-by-step into subdirectories until they confirm the final choice.

* **Return Mechanism**:
  The navigation always allows selecting `.` (stay in place) or `..` (go up one level), providing flexible movement within the filesystem.

## Why Use It?

* **Efficient Navigation**: Instead of typing long paths, you can jump through directories interactively.
* **Power of fzf**: The fuzzy finder enables quick filtering of directories by typing partial names.
* **Drop-in Replacement**: Works like the standard `cd` but with an extra superpower when using `-r`.

## Example Usage

```bash
cd -r
```

This opens an interactive session where you can rapidly navigate and select a target directory.