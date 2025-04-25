cd() {
    local ARGV_SAVE="$@"
    local opt
    local opt_L=0
    local opt_P=0
    local opt_e=0
    local opt_at=0
    local opt_r=0
    local dir=""

    while getopts ":LPe@r" opt; do
        case "$opt" in
            L) opt_L=1 ;;
            P) opt_P=1 ;;
            e) opt_e=1 ;;
            @) opt_at=1 ;;
            r) opt_r=1 ;;
            \?)
                echo "無効なオプション: -$OPTARG" >&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND - 1))

    if [[ $opt_r -eq 1 ]]; then
        cdr
        return
    else
        builtin cd "$ARGV_SAVE"
        return
    fi
}
function cdr () {
    local PWD_START="$PWD"
    local CURPWD="$PWD"
    local DOTGLOB_SAVE="$(shopt -p dotglob)"
    while true; do
        shopt -s dotglob;
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
        eval "$DOTGLOB_SAVE"
        local SELECTED="$(echo "$DIRLIST" | MSYS2_ARG_CONV_EXCL="*" fzf --layout reverse-list --no-sort --header="PWD=$CURPWD" )"
        if [[ -z "$SELECTED" || "$SELECTED" == "." ]]; then
            builtin cd "$CURPWD"
            break
        else
            CURPWD="$(builtin cd "$CURPWD"; builtin cd "$SELECTED"; echo "$PWD")"
        fi
    done
}