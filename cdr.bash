# Define a custom 'cd' function that extends the behavior of the builtin 'cd'
function cd() {
    # Save the original arguments passed to 'cd'
    local ARGV_SAVE=("$@")
    local opt
    # Flags for supported options
    local opt_L=0
    local opt_P=0
    local opt_e=0
    local opt_at=0
    local opt_r=0
    local dir=""

    # Reset option parsing
    unset OPTIND
    # Parse options: L, P, e, @, r
    while getopts ":LPe@r" opt; do
        case "$opt" in
            L) opt_L=1 ;;  # Logical option (not used in this script)
            P) opt_P=1 ;;  # Physical option (not used in this script)
            e) opt_e=1 ;;  # Error option (not used in this script)
            @) opt_at=1 ;; # '@' option (custom flag, not standard)
            r) opt_r=1 ;;  # Recursive directory navigation option
            \?)
                # Invalid option handler
                echo "invalid option: -$OPTARG" >&2
                return 1
                ;;
        esac
    done
    # Shift processed options away
    shift $((OPTIND - 1))

    # If -r option is given, invoke 'cdr' function instead of builtin 'cd'
    if [[ $opt_r -eq 1 ]]; then
        cdr
        return
    else
        # Otherwise, fallback to builtin 'cd' with the original arguments
        builtin cd "${ARGV_SAVE[@]}"
    fi
}

# Define 'cdr' function, which provides an interactive directory selector using fzf
function cdr () {
    # Store the starting directory
    local PWD_START="$PWD"
    local CURPWD="$PWD"
    # Save current dotglob setting (controls whether hidden files are matched by '*')
    local DOTGLOB_SAVE="$(shopt -p dotglob)"
    while true; do
        # Enable dotglob so that hidden directories are included in listings
        shopt -s dotglob;
        # Build a list of directories:
        # - Always include '.' and '..'
        # - List all subdirectories in the current directory
        # - Include the starting directory for easy return
        local DIRLIST="$(
            printf .\\n..\\n ;
            builtin cd "$CURPWD";
            for item in * ; do
                if [[ -d "$item" ]]; then
                    echo "$item"
                fi
            done;
            echo "$PWD_START"
        )"
        # Restore previous dotglob setting
        eval "$DOTGLOB_SAVE"
        # Use fzf to present the list of directories to the user for selection
        local SELECTED="$(echo "$DIRLIST" | fzf --layout reverse-list --no-sort --header="PWD=$CURPWD" )"
        # If the user cancels or selects ".", stay in the current directory and exit
        if [[ -z "$SELECTED" || "$SELECTED" == "." ]]; then
            builtin cd "$CURPWD"
            break
        else
            # Otherwise, update CURPWD to the newly selected directory
            CURPWD="$(builtin cd "$CURPWD"; builtin cd "$SELECTED"; echo "$PWD")"
        fi
    done
}
