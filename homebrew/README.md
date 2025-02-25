# Homebrew Bundle

## Backup

```shell
$ brew bundle dump \
    --describe \
    --force \
    --no-vscode \
    --file $HOME/.config/homebrew/Brewfile
```

## Usage

```shell
$ mkdir -p $HOME/.config/homebrew

$ curl -o $HOME/.config/homebrew/Brewfile \
    https://raw.githubusercontent.com/monsterhxw/dotfiles/main/homebrew/Brewfile

$ brew bundle check --file $HOME/.config/homebrew/Brewfile

$ brew bundle install --file $HOME/.config/homebrew/Brewfile
```
