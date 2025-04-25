function cdr () {
    local PWD_START="$PWD"
    local CURPWD="$PWD"
    local DOTGLOB_SAVE="$(shopt -p dotglob)"
    while true; do
        shopt -s dotglob;
        local DIRLIST="$(
            printf .\\n..\\n ;
            cd "$CURPWD";
            for item in * ; do
                    if [[ -d "$item" ]]; then
                        echo "$item"
                    fi
            done;
            echo "$PWD_START"
        )"
        eval "$DOTGLOB_SAVE"
        local SELECTED="$(echo "$DIRLIST" | MSYS2_ARG_CONV_EXCL="*" fzf --layout reverse-list --no-sort --header="PWD=$CURPWD" )"
        if [[ -z "$SELECTED" || "$SELECTED" == "." ]]; then
            builtin cd "$CURPWD"
            break
        else
            CURPWD="$(cd "$CURPWD"; cd "$SELECTED"; echo "$PWD")"
        fi
    done
}