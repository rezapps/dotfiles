##########################################
# Simple bash prompt to print git status
# and current working directory
# Easy to understand and modify script
##########################################

#!/bin/sh

# list of colors
clr_black='\001\e[30m\002'
clr_gray='\001\e[1;30m\002'
clr_lite_grey='\001\e[37m\002'
clr_red='\001\e[31m\002'
clr_light_red='\001\e[1;31m\002'
clr_green='\001\e[32m\002'
clr_lite_green='\001\e[1;32m\002'
clr_yellow='\001\e[33m\002'
clr_blue='\001\e[34m\002'
clr_lite_blue='\001\e[1;34m\002'
clr_purple='\001\e[0;35m\002'
clr_lite_purple='\001\e[1;35m\002'
clr_cyan='\001\e[36m\002'
clr_lite_cyan='\001\e[1;36m\002'
clr_white='\001\e[1;37m\002'
clr_reset='\001\e[0m\002'


# Check Git status and colorize output
check_status() {
    local status
    local output=''
    local patterns=(' M '  ' D ' '?? ' '## ')
    local clr_cods=("$clr_purple" "$clr_red" "$clr_cyan" "$clr_yellow")
    local icons=('M' '✘' 'U' '⇡')
    local looper=0

    status=$(git status --short 2>&1)

    if [ -z "$status" ]; then
        output+="$clr_lite_green✔ $clr_reset"
    fi

    for pattern in "${patterns[@]}"; do
        count=$(echo "$status" | grep -c "${pattern}")
        if [[ "$count" -gt 0 ]]; then
            output+="${clr_cods[$looper]}${icons[$looper]}:$count$clr_reset "
        fi
        ((looper++))
    done

    printf "%b\n" "$output"
}

# Get Git branch and call check_status function
# to get the git status for current branch
get_git_status() {
    local branch
    local output=''
    gitbranch="$clr_purple$clr_reset"

    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

    if [[ -n "$branch" ]]; then
        output="$(check_status)"
        printf "[$gitbranch $branch $output]  "
    fi

}

# Set PS1 prompt
export PS1="(\u@\h)[\W] \$(get_git_status)"
