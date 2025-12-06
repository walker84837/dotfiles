#!/usr/bin/env bash

# usage: git-amend "YYYY-MM-DDThh:mm:ss+01:00" "Name <email>"

if [ -z "$1" ] || [ "$1" == "--help" ]; then
	echo 'usage: git-amend "YYYY-MM-DDThh:mm:ss+01:00" "Name <email>"' >&2
	echo 'example: git-amend "2022-01-01T00:00:00+01:00" "john <john@example.com>"' >&2
	exit 1
fi

date="$1"
author="${2:-$(git config user.name) <$(git config user.email)>}"
git commit --amend --no-edit --author="$author" --date "$date" -S
