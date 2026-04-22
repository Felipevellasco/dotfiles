#!/usr/bin/env sh

GITHUB_USERNAME="Felipevellasco"

# -e: exit on error
# -u: exit on unset variables
set -eu

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

bin_dir="${tmp_dir}/bin"

# Set installer
if command -v curl >/dev/null; then
	installer="curl -fsSL"
elif command -v wget >/dev/null; then
	installer="wget -qO-"
else
	echo "To use this setup script, you must have curl or wget installed." >&2
	exit 1
fi

# Check for git
if ! command -v git >/dev/null; then
	echo "You need Git installed on your machine to download the dotfiles repository." >&2
	exit 1
fi

# Install chezmoi locally if needed
if ! chezmoi="$(command -v chezmoi)"; then
	chezmoi="${bin_dir}/chezmoi"
	echo "Temporarily installing chezmoi to '${chezmoi}'" >&2
	chezmoi_install_script="$(${installer} get.chezmoi.io)"

	sh -c "${chezmoi_install_script}" -- -b "${bin_dir}"
	unset chezmoi_install_script
fi

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
exec "$chezmoi" "$@"

unset chezmoi
