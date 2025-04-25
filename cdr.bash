cdr() {
    while true; do
        local DOTGLOB_SAVE="$(shopt -p dotglob)"
        shopt -s dotglob
        local DIRLIST="$(echo ..;
        for item in * ; do
                if [[ -d "$item" ]]; then
                    echo "$item"
                fi
        done )"
        eval "$DOTGLOB_SAVE"
        local SELECTED="$(echo "$DIRLIST" | fzf --layout reverse-list --no-sort --header="PWD=$PWD" )"
        if [[ -z "$SELECTED" ]]; then
            break
        else
            builtin cd "$SELECTED"
        fi
    done
}