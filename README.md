# dotfiles

This repository contains the configuration files for my machines. For installation, [Chezmoi](chezmoi.io) is mandatory as the chosen dotfiles manager.

The setup is currently under testing for the following operating systems:
- Windows
- Arch Linux

I am planning on expanding the repository to support Ansible playbooks and also to be able to install dependencies based on whether the tools to be configured should be for a headless (no GUI) machine or for a full-on desktop in the case of Linux.

# How to run

```bash
export GITHUB_USERNAME=Felipevellasco
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```
