#!/bin/bash
# ---------------------------------------------------------------------------
# replace-github-ssh-key - To create or replace a Github ssh key for the currentachine

# Copyright 2019, Andrew Dias

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License at <http://www.gnu.org/licenses/> for
# more details.

# Usage: replace-github-ssh-key [-h|--help] [-h] [-k]

# Revision history:
# 2019-02-16 Created by new_script ver. 1.0
# ---------------------------------------------------------------------------

PROGNAME=${0##*/}
VERSION="0.1"

clean_up() { # Perform pre-exit housekeeping
    return
}

error_exit() {
    echo -e "${PROGNAME}: ${1:-"Unknown Error"}" >&2
    clean_up
    exit 1
}

graceful_exit() {
    clean_up
    exit
}

signal_exit() { # Handle trapped signals
    case $1 in
        INT)
        error_exit "Program interrupted by user" ;;
        TERM)
            echo -e "\n$PROGNAME: Program terminated" >&2
        graceful_exit ;;
        *)
        error_exit "$PROGNAME: Terminating on unknown signal" ;;
    esac
}

usage() {
    echo -e "Usage: $PROGNAME [-h|--help] [-h] [-k]"
}

help_message() {
  cat <<- _EOF_
  $PROGNAME ver. $VERSION
  To create or replace a Github ssh key for the current machine

  $(usage)

  Options:
  -h, --help      Display this help message and exit.
  -u, --user      Github username
  -t, --token     Github personal access token
  -k, --keyname   Public key name (assumed to be under ~/.ssh; do not inlcude .pub extension)

_EOF_
    return
}

# Trap signals
trap "signal_exit TERM" TERM HUP
trap "signal_exit INT"  INT



# Parse command-line
while [[ -n $1 ]]; do
    case $1 in
        -h | --help)
        help_message; graceful_exit ;;
        -u | --user)
        user="$2"; shift ;;
        -t | --token)
        token="$2"; shift ;;
        -k | --keyname)
        keyname="$2"; shift ;;
        -* | --*)
            usage
        error_exit "Unknown option $1" ;;
        *)
        echo "Argument $1 to process..." ;;
    esac
    shift
done

# Main logic

# public key location assumed to be under ~/.ssh
path=$HOME/.ssh/$keyname.pub

# check if the path is available
[[ -f $path ]] || error_exit "$path: no such file or directory"
key_data=$(cat "$path")

# check if key exists
res=$(
    curl --write-out "HTTPSTATUS:%{http_code}" --silent \
    -u "$user:$token" \
    https://api.github.com/user/keys
)

# extract the body and status
# technique from https://gist.github.com/maxcnunes/9f77afdc32df354883df
res_body=$(echo "$res" | sed -e 's/HTTPSTATUS:.*//g')
res_status=$(echo "$res" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

if [ $res_status != "200" ]
then
    error_exit "Unable to fetch keys for user - received $res_status\n$res_body"
fi

# extract the key ID
key_id=$(echo $res_body| jq --arg title "$keyname" '.[] | select(.title==$title) | .id')

# delete the key if it exists
if [ $key_id ]
then
    # store the whole response with the status at the and
    res=$(
        curl --write-out "HTTPSTATUS:%{http_code}" --silent \
        -u "$user:$token" \
        -X DELETE \
        https://api.github.com/user/keys/$key_id
    )

    # extract the body and status
    # technique from https://gist.github.com/maxcnunes/9f77afdc32df354883df
    res_body=$(echo "$res" | sed -e 's/HTTPSTATUS:.*//g')
    res_status=$(echo "$res" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

    if [ $res_status != "204" ]
    then
        error_exit "Unable to delete key ID $key_id - received $res_status\n$res_body"
    fi
fi

# create a new key
# store the whole response with the status at the and
res=$(
    curl --write-out "HTTPSTATUS:%{http_code}" --silent \
    -u "$user:$token" \
    --data "{\"title\":\"$keyname\",\"key\":\"$key_data\"}" \
    https://api.github.com/user/keys
)

# extract the body and status
# technique from https://gist.github.com/maxcnunes/9f77afdc32df354883df
res_body=$(echo "$res" | sed -e 's/HTTPSTATUS:.*//g')
res_status=$(echo "$res" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

# exit on error
if [ $res_status != "201" ]
then
    error_exit "Unable to create key - received $res_status\n$res_body"
fi

graceful_exit
