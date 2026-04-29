#!/usr/bin/env bash

# Start profiling
__profile_start=$(date +%s%3N)

# Initialize colors
cyan=$(tput setaf 6)
reset=$(tput sgr0)

echo "${cyan}---------- Yazi ----------${reset}"
ya pkg install

# End profiling
__profile_end=$(date +%s%3N)
__profile_elapsed=$((__profile_end - __profile_start))
echo "Bootstrapping completed in ${__profile_elapsed} ms."
echo -e "${cyan}---------- End -----------\n${reset}"
