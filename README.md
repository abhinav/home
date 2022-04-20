This uses [chezmoi](https://www.chezmoi.io/) to manage the dotfiles.

Install chezmoi:

```bash
# macOS
brew install chezmoi

# ArchLinux
pacman -S chezmoi

# Others
sh -c "$(curl -fsLS chezmoi.io/get)"
```

Update dotfiles:

```bash
chezmoi init https://github.com/abhinav/dotfiles.git
chezmoi diff
chezmoi apply -v
```
