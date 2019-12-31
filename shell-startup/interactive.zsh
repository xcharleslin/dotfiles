# First, source aliases.
source shared/aliases.sh

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=99999
SAVEHIST=99999
setopt autocd
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/charles/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Start of manually added lines
# Shares history, live, across all terminals.
setopt SHARE_HISTORY
# Adds timestamps to history.
setopt EXTENDED_HISTORY

# Prompt string.
# precmd() is a zsh hook that always executes before a prompt.
precmd() {
    local ANSI_SAVE=$'\e[s'
    local ANSI_RESTORE=$'\e[u'
    local ANSI_RESET=$'\e[0m'
    local ANSI_FG_WHITE=$'\e[37m'
    local ANSI_FG_BRIGHT_BLACK=$'\e[90m'
    local ANSI_BG_BRIGHT_BLACK=$'\e[100m'
    local NEWLINE=$'\n'

    # print is a zsh builtin, and -P applies prompt formatting I think?
    local STATUS_STRING="$(print -P $'%(?.%B%F{green}√.%B%F{red}?%?)%f%b')"
    local USER_HOST_DIR="$(whoami)@$(hostname):$(print -P %~)"
    local DATETIME="$(date +'%Y-%m-%d %H:%M:%S')"

    local LEFT_PROMPT=""
    # LEFT_PROMPT+="${ANSI_BG_BRIGHT_BLACK}"
    LEFT_PROMPT+="${STATUS_STRING} "
    LEFT_PROMPT+="${ANSI_FG_WHITE}${USER_HOST_DIR}"
    local RIGHT_PROMPT="${DATETIME}"
    local BOTTOM_PROMPT="${ANSI_RESET}%# "

    local NUM_COLUMNS=$(tput cols)
    # Strips ANSI color codes to count length easier.
    local LEFT_PROMPT_STRIPPED=$(sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <<<"$LEFT_PROMPT")
    local PADDING=$(( ${NUM_COLUMNS} - ${#LEFT_PROMPT_STRIPPED} ))

    # PROMPT is the variable that zsh reads.
    PROMPT=$(printf \
        ${NEWLINE}%s%${PADDING}s${NEWLINE}%s \
        ${LEFT_PROMPT} ${RIGHT_PROMPT} ${BOTTOM_PROMPT} \
    )
}
