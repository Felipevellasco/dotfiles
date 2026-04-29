# dotfiles

This repository contains the configuration files for my machines.
The setup is currently under testing for the following operating systems:
- Arch Linux
- Ubuntu Linux
- Linux Mint
- Windows (*WIP*)

# How to install

To install this configuration, you are required to have the following packages installed on your machine:
- [Git](https://git-scm.com)
- [curl](https://github.com/curl/curl) or [wget](https://www.gnu.org/software/wget/)

You can also install [Chezmoi](https://www.chezmoi.io) manually, though the one-liner below will try to install it for your user if not found.
All these packages can be installed using the package manager of your operating system (or by manually downloading them on Windows).

On Linux:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Felipevellasco/dotfiles/main/exact_dot_bootstrap/install.sh)"
```

On Windows:
```bash
powershell -c "irm https://raw.githubusercontent.com/Felipevellasco/dotfiles/main/exact_dot_bootstrap/install.ps1 | iex"
```

During the execution of the download script all required packages will be installed using Ansible.  
This process will only happen once, but should you want to re-run the playbook, you can run `dotfiles-install` on your Bash/Zsh terminal.
