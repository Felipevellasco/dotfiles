# dotfiles

This repository contains the configuration files for my machines.
The setup is currently under testing for the following operating systems:
- Windows
- Arch Linux

I am planning on expanding the repository to support Ansible playbooks and also to be able to install dependencies based on whether the tools to be configured should be for a headless (no GUI) machine or for a full-on desktop in the case of Linux.

# How to install

To install this configuration, you are required to have the following packages installed on your machine:
- [Git](https://git-scm.com)
- [Chezmoi](https://www.chezmoi.io)
- [curl](https://github.com/curl/curl)

All these packages can be installed using the package manager of your operating system (or by manually downloading them on Windows).

On Linux:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Felipevellasco/.dotfiles/main/dot_bootstrap/install.sh)"
```

On Windows:
```bash
powershell -c "irm https://raw.githubusercontent.com/Felipevellasco/.dotfiles/main/dot_bootstrap/install.ps1 | iex"
```
