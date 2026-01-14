# Tmux Configuration

My personal tmux configuration with Nord-inspired theme.

## Theme

Theme file: [theme.conf](./themes/theme.conf)

Load the theme in **tmux.conf**

```tmux
source-file "$YOUR_PATH/theme.conf"
```

CPU/RAM metrics scripts: [themes/scripts/](./themes/scripts/) **(copied from [tmux-plugins  tmux-cpu](https://github.com/tmux-plugins/tmux-cpu))**

<details>
<summary>Disable CPU/RAM display</summary>

Comment out [lines 43-47 in theme.conf](./themes/theme.conf#L43-L47)

```sh
# Comment the lines below if you don't want CPU/RAM block
sh_cpu="#($HOME/.config/tmux/themes/scripts/cpu_percentage.sh)"
sh_ram="#($HOME/.config/tmux/themes/scripts/ram_percentage.sh)"
block_cpu_ram="#[fg=${nord_four_snow},bg=${nord_zero_black},nobold]  ${sh_cpu}   ${sh_ram} #[default]"
set -ag status-right "${block_cpu_ram}"
```

</details>


### Normal Mode

> The default status line appearance:

![Normal Mode](../.assets/tmux/tmux-theme-1.png)

### Prefix Mode

> Status line after pressing the prefix key (`Ctrl+b`):

![Prefix Mode](../.assets/tmux/tmux-theme-2.png)

### Copy Mode

> Status line when in copy mode:

![Copy Mode](../.assets/tmux/tmux-theme-3.png)
