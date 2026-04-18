#!/usr/bin/env sh

GITHUB_USERNAME="Felipevellasco"

# -e: exit on error
# -u: exit on unset variables
set -eu

errors=0
for tool in git chezmoi; do
	if ! command -v "$tool" >/dev/null; then
		echo "Error: $tool not found." >&2
		errors=errors+1
	fi
	echo "Please install missing dependencies using your packaga manager before running the script." >&2
	exit 1
done

if [ ! -d ".git" ]; then
	echo "Initializing from remote repository..." >&2
	set -- init --apply "$GITHUB_USERNAME"
else
	echo "Initializing from local source..." >&2
	# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
	script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
	set -- init --apply --source="${script_dir}"
fi

echo "Running 'chezmoi $*'" >&2
exec chezmoi "$@"
