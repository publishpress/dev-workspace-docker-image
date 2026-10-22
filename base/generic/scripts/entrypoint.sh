#!/bin/sh
# Drop root to the host user so bind-mounted build output is not root-owned.
set -eu

run() {
    if [ "$#" -eq 0 ]; then
        exec /bin/bash -l
    fi
    exec "$@"
}

if [ "$(id -u)" -ne 0 ]; then
    run "$@"
fi

target_uid=""
target_gid=""

if [ -n "${HOST_UID:-}" ] && [ -n "${HOST_GID:-}" ] && [ "$HOST_UID" != "0" ]; then
    target_uid=$HOST_UID
    target_gid=$HOST_GID
elif [ -e /project ]; then
    target_uid=$(stat -c '%u' /project)
    target_gid=$(stat -c '%g' /project)
fi

if [ -z "$target_uid" ] || [ "$target_uid" = "0" ]; then
    run "$@"
fi

user_name=$(awk -F: -v uid="$target_uid" '$3 == uid { print $1; exit }' /etc/passwd)

if [ -z "$user_name" ]; then
    group_name=$(awk -F: -v gid="$target_gid" '$3 == gid { print $1; exit }' /etc/group)
    if [ -z "$group_name" ]; then
        group_name=devuser
        addgroup -g "$target_gid" "$group_name"
    fi
    user_name=devuser
    adduser -D -u "$target_uid" -G "$group_name" -h /home/devuser -s /bin/bash "$user_name"
fi

mkdir -p /home/devuser/.composer /home/devuser/.npm

if [ ! -f /home/devuser/.bash_profile ] && [ -f /root/.bash_profile ]; then
    cp /root/.bash_profile /home/devuser/.bash_profile
fi

if [ ! -f /home/devuser/.bashrc ] && [ -f /root/.bashrc ]; then
    cp /root/.bashrc /home/devuser/.bashrc
fi

if [ -f /root/.zshrc.local ]; then
    cp /root/.zshrc.local /home/devuser/.zshrc.local
fi

chown -R "${target_uid}:${target_gid}" /home/devuser

export HOME=/home/devuser
export USER="$user_name"
export COMPOSER_HOME=/home/devuser/.composer

if [ "$#" -eq 0 ]; then
    exec su-exec "${target_uid}:${target_gid}" /bin/bash -l
fi

exec su-exec "${target_uid}:${target_gid}" "$@"
