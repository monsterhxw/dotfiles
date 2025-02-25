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
$ brew bundle check --file $HOME/.config/homebrew/Brewfile

$ brew bundle install --file $HOME/.config/homebrew/Brewfile
```
