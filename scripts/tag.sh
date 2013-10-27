#!/bin/bash

set -o errexit
set -o nounset

repo=$(realpath "$(dirname "$(realpath -- "${BASH_SOURCE[0]}")")/..")
cd -- "$repo"

if git status | grep -v 'working directory clean'; then
    echo 'Uncommited changes, aborting!'
    exit 1
fi

echo "Previous tag is sort of this $(git describe)"

read -p 'Enter your new tag: ' -r
tag="${REPLY}"

read -p 'Enter a message to go with the tag: ' -r
message="${REPLY}"

git tag -s "$tag" -m "$message"

