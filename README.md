# dotfiles with [chezmoi](https://chezmoi.io)

The goal is to slowly make this cross platform but for now this is a windows exclusive

## Getting Started

The setup process will differ slightly between systems

### Windows

To pull and apply the dotfiles we need `git` and `chezmoi`.
To do so run the following in a cmd console

```winbatch
winget install -e --id Git.Git
winget install -e --id twpayne.chezmoi
```

Once both are installed run

```winbatch
chezmoi init https://github.com/mbaklor/dotfiles.git
chezmoi apply
```

now we should have all our dotfiles in place as well as the apps we need installed

In case the apply fails to create symlinks with `required privilege is not held by the client`, enable developer mode in windows settings
