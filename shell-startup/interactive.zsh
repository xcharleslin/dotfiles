# First, source aliases.
source shared/aliases.sh

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=99999
SAVEHIST=99999
setopt autocd
bindkey -e

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Shares history, live, across all terminals.
setopt SHARE_HISTORY
setopt HISTIGNOREALLDUPS


# Prompt string.
# precmd() is a zsh hook that always executes before a prompt.
precmd() {
    local ANSI_SAVE=$'\e[s'
    local ANSI_RESTORE=$'\e[u'
    local ANSI_RESET=$'\e[0m'
    local ANSI_BOLD=$'\e[1m'
    local ANSI_FG_BLACK=$'\e[30m'
    local ANSI_FG_RED=$'\e[31m'
    local ANSI_FG_GREEN=$'\e[32m'
    local ANSI_FG_YELLOW=$'\e[33m'
    local ANSI_FG_BLUE=$'\e[34m'
    local ANSI_FG_MAGENTA=$'\e[35m'
    local ANSI_FG_CYAN=$'\e[36m'
    local ANSI_FG_WHITE=$'\e[37m'
    local ANSI_FG_BRIGHT_BLACK=$'\e[90m'
    local ANSI_FG_BRIGHT_RED=$'\e[91m'
    local ANSI_FG_BRIGHT_GREEN=$'\e[92m'
    local ANSI_FG_BRIGHT_YELLOW=$'\e[93m'
    local ANSI_FG_BRIGHT_BLUE=$'\e[94m'
    local ANSI_FG_BRIGHT_MAGENTA=$'\e[95m'
    local ANSI_FG_BRIGHT_CYAN=$'\e[96m'
    local ANSI_FG_BRIGHT_WHITE=$'\e[97m'
    local ANSI_BG_BLACK=$'\e[40m'
    local ANSI_BG_RED=$'\e[41m'
    local ANSI_BG_GREEN=$'\e[42m'
    local ANSI_BG_YELLOW=$'\e[43m'
    local ANSI_BG_BLUE=$'\e[44m'
    local ANSI_BG_MAGENTA=$'\e[45m'
    local ANSI_BG_CYAN=$'\e[46m'
    local ANSI_BG_WHITE=$'\e[47m'
    local ANSI_BG_BRIGHT_BLACK=$'\e[100m'
    local ANSI_BG_BRIGHT_RED=$'\e[101m'
    local ANSI_BG_BRIGHT_GREEN=$'\e[102m'
    local ANSI_BG_BRIGHT_YELLOW=$'\e[103m'
    local ANSI_BG_BRIGHT_BLUE=$'\e[104m'
    local ANSI_BG_BRIGHT_MAGENTA=$'\e[105m'
    local ANSI_BG_BRIGHT_CYAN=$'\e[106m'
    local ANSI_BG_BRIGHT_WHITE=$'\e[107m'
    local NEWLINE=$'\n'

    # print is a zsh builtin, and -P applies prompt formatting I think?
    local STATUS_STRING="$(print -P $'%(?.%B%F{green}√.%B%F{red}?%?)%f%b')"
    local DATETIME="[$(date +'%Y-%m-%d %H:%M:%S')]"

    local LEFT_PROMPT=""
    # LEFT_PROMPT+="${ANSI_BG_BRIGHT_BLACK}"
    LEFT_PROMPT+="${STATUS_STRING} "
    LEFT_PROMPT+="${ANSI_FG_WHITE}$(whoami)"
    LEFT_PROMPT+="${ANSI_FG_WHITE}${ANSI_BOLD}@$(hostname)${ANSI_RESET}"
    LEFT_PROMPT+="${ANSI_FG_BRIGHT_CYAN}:$(print -P %~)"
    local RIGHT_PROMPT="${ANSI_BG_BLACK}${ANSI_FG_BRIGHT_BLACK}${DATETIME}"
    local BOTTOM_PROMPT="${ANSI_RESET}%B%#%b "

    local NUM_COLUMNS=$(tput cols)
    # Strips ANSI color codes to count length easier.
    local LEFT_PROMPT_STRIPPED=$(sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <<<"$LEFT_PROMPT")
    local RIGHT_PROMPT_STRIPPED=$(sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <<<"$RIGHT_PROMPT")
    local PADDING=$(( ${NUM_COLUMNS} - ${#LEFT_PROMPT_STRIPPED} + ${#RIGHT_PROMPT} - ${#RIGHT_PROMPT_STRIPPED}))

    # PROMPT is the variable that zsh reads.
    PROMPT=$(printf \
        ${NEWLINE}%s%${PADDING}s${NEWLINE}%s \
        ${LEFT_PROMPT} ${RIGHT_PROMPT} ${BOTTOM_PROMPT} \
    )
}
