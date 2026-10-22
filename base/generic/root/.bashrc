export PLUGIN_NAME="${PLUGIN_NAME:-Base Image}"
export PLUGIN_TYPE="${PLUGIN_TYPE:-FREE}"
export LANG="${LANG:-en_US.UTF-8}"
export LANGUAGE="${LANGUAGE:-en_US:en}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"
export PROJECT_PATH="${PROJECT_PATH:-/project}"
export PATH="/project/node_modules/.bin:/project/vendor/bin:/project/lib/vendor/bin:/scripts:/scripts/deprecated-scripts:${PATH}"

alias wp="wp --allow-root"
alias proj='cd "$PROJECT_PATH"'
alias ppbuild="pbuild"
alias c="composer"

if [[ -r "$PROJECT_PATH/dev-workspace/cache/gh-token.txt" ]]; then
    gh auth login --with-token < "$PROJECT_PATH/dev-workspace/cache/gh-token.txt"
fi

if [[ -n "${DROPBOX_ACCESS_TOKEN:-}" ]]; then
    printf 'OAUTH_ACCESS_TOKEN=%s\n' "$DROPBOX_ACCESS_TOKEN" > "$HOME/.dropbox_uploader"
fi

# Derived workspace images still provide this Bash-compatible legacy filename.
if [[ -r "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
fi

export PLUGIN_NAME PLUGIN_TYPE

if [[ $- == *i* ]]; then
    eval "$(starship init bash)"
fi
