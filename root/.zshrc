# If you come from bash you might have to change your $PATH.
export PATH=/project/node_modules/.bin:/project/vendor/bin:/project/lib/vendor/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="ys"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git gh asdf wp-cli docker)

source $ZSH/oh-my-zsh.sh

# User configuration

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PROJECT_PATH="/project"

# Set default values for PLUGIN_NAME and PLUGIN_TYPE if not set
export PLUGIN_NAME=${PLUGIN_NAME:-"Base Image"}
export PLUGIN_TYPE=${PLUGIN_TYPE:-"GENERIC"}

# Set the prompt color based on PLUGIN_TYPE
if [[ "$PLUGIN_TYPE" == "PRO" ]]; then
    COLOR="%{$bg[yellow]%}"
elif [[ "$PLUGIN_TYPE" == "FREE" ]]; then
    COLOR="%{$bg[cyan]%}"
elif [[ "$PLUGIN_TYPE" == "GENERIC" ]]; then
    COLOR="%{$bg[green]%}"
fi

export PROMPT="%{$bg[magenta]%}%{$fg[white]%} 🐧 Dev-Workspace %{$reset_color%} $COLOR%{$fg[black]%} $PLUGIN_NAME $PLUGIN_TYPE %{$reset_color%}
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} %(#,%{$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$fg[cyan]%}%n) %{$reset_color%}@ %{$fg[green]%}%m %{$reset_color%}in %{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}${hg_info}${git_info}${svn_info}${venv_info} [%*] $exit_code
%{$terminfo[bold]$fg[magenta]%}➜ %{$reset_color%}"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"
alias wp="wp --allow-root"
alias proj="cd $PROJECT_PATH"
alias ppbuild="pbuild"
alias c="composer"

# If GH auth file exists, login to gh command
if [[ -f $PROJECT_PATH/dev-workspace/cache/gh-token.txt ]]; then
     GH_TOKEN=$(cat $PROJECT_PATH/dev-workspace/cache/gh-token.txt)
     gh auth login --with-token <<< $GH_TOKEN
fi

# If the env var DROPBOX_ACCESS_TOKEN is set, write it to /root/.dropbox_uploader
if [[ -n $DROPBOX_ACCESS_TOKEN ]]; then
    echo "OAUTH_ACCESS_TOKEN=${DROPBOX_ACCESS_TOKEN}" > /root/.dropbox_uploader
fi

export PATH="/scripts:$PATH"

if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
    echo "🎉 Loaded local zshrc from ~/.zshrc.local"
fi
