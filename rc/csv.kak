
# User options
# ‾‾‾‾‾‾‾‾‾‾‾‾

declare-option str csv_sep ','

declare-option str csv_colors "yellow red cyan green blue rgb:993286 magenta"

 
# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](csv) %{
    set-option buffer filetype csv
}

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

declare-option -hidden regex csv_rgx ""
declare-option -hidden str-list csv_faces

# Idea: given a separator as param and color list as global variable,
# build a list of faces and corresponding regular expression catching the
# columns. This way, the number of used colors can be determined from the
# color list.
define-command -hidden csv-prepare-rgx -params 1 %{
    evaluate-commands -draft %sh{
        sep=$1
        # The first reg exp pattern starts the line, and is thus a bit
        # different compared to the rest that are handled in the loop.
        rgx="(^[^\n$sep]*[$sep\$])?"
        face_num=1
        eval "set -- $kak_quoted_opt_csv_colors"
        length=$#
        for fc in $@; do
            if [ $face_num -gt 1 ]
            then rgx="$rgx([^\n$sep]*[$sep\$])?"
            fi
            face_elem="$face_num:$fc"
            face_num=`expr $face_num + 1`
            echo "
                evaluate-commands -draft %{
                    set-option -add window csv_faces $face_elem
                }
            "
        done
        echo "set-option window csv_rgx '$rgx'"
    }
}

define-command csv-enable -params 1 -docstring "Enable the csv mode in the window with given separator.\nFor example: csv-enable ';'" %{
    remove-highlighter window/csv
    csv-prepare-rgx %arg{1}
    add-highlighter window/csv regions
    add-highlighter window/csv/comment region ^        \n   group
    add-highlighter window/csv/comment/ regex %opt{csv_rgx} %opt{csv_faces}
    # echo -debug "csv_faces = %opt{csv_faces}"
    # echo -debug "csv_rgx = %opt{csv_rgx}"
}

define-command csv-disable -docstring "Disable the csv highlighter in the window." %{
    remove-highlighter window/csv
}

hook global WinSetOption filetype=csv %{
    csv-enable %opt{csv_sep}
}

hook global WinSetOption filetype=(?!csv).* %{
    remove-highlighter window/csv
}

