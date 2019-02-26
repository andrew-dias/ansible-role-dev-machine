# ansible-role-dev-machine

This [Ansible](https://github.com/ansible/ansible) role configures my [Pop_OS!](https://system76.com/pop) 18.10 development machine, including applications, OS configuration, and dotfiles.

The role includes:

- [Zsh](http://zsh.sourceforge.net) with configuration, plugins and colour settings
- [Node Version Manager](https://github.com/creationix/nvm) and desired node versions
- [SDKMAN!](https://sdkman.io)
- [Neovim](https://neovim.io) with configuration and plugins
- [Tmux](https://github.com/tmux/tmux) with configuration
- [jq](https://stedolan.github.io/jq)
- dconf-editor
- Fonts
- [Visual Studio Code](https://code.visualstudio.com)
- [Gitkraken](https://www.gitkraken.com)
- [Google Chrome](https://www.google.com/chrome)
- [Spotify](https://www.spotify.com)
- [Postman](https://www.getpostman.com)
- [Jetbrains Toolbox](https://www.jetbrains.com/toolbox)
- [Docker CE](https://www.docker.com)
- [VirtualBox](https://www.virtualbox.org)
- [Gnome extensions](https://github.com/andrew-dias/ansible-gnome-extensions)
- Scripts and dotfiles
- Generate SSH keypair for `user@machine` and upload to Github

## Requirements

None.

## Role Variables

The role assumes the usage of the default [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) locations for user config, data and cache folders.

| Variable              | Default Value        |
| --------------------- | -------------------- |
| `xdg.XDG_CACHE_HOME`  | `$HOME/.cache`       |
| `xdg.XDG_CONFIG_HOME` | `$HOME/.config`      |
| `xdg.XDG_DATA_HOME`   | `$HOME/.local/share` |

Locations of certain zsh folders can be overriden.

| Variable     | Default Value                         |
| ------------ | ------------------------------------- |
| `zsh.zshenv` | `/etc/zsh/zshenv`                     |
| `zsh.fpath`  | `/usr/local/share/zsh/site-functions` |

Specific software versions can be overriden.

| Variable        | Default Value       |
| --------------- | ------------------- |
| `nvm.version`   | `0.34.0`            |
| `node.versions` | `[10.15.1, 8.15.0]` |

A optional ssh key passphrase can be set.

| Variable             | Default Value |
| -------------------- | ------------- |
| `ssh_key_passphrase` | `empty`       |

The list of fonts to install can be overriden by adding to the `fonts` list.

```
# fonts
fonts:
  - name: hasklig
    archive_url: https://github.com/i-tu/Hasklig/releases/download/1.1/Hasklig-1.1.zip
```

## Dependencies

- `cmprescott.chrome`
- `ngetchell.vscode`

## Example Playbook

    - hosts: localhost
      roles:
        andrew-dias.ansible-role-dev-machine

      # optionally prompt for ssh key passphrase
      - vars_prompt:
        - name: "ssh_key_passphrase"
          prompt: "Enter SSH key passphrase"
          private: yes

Once run, you should

1. Log out to ensure all changes are activated
1. Open a terminal and choose your colour theme by typing `base16` followed by a tab to perform tab completion.

## License

MIT

## Author Information

This role was created in 2019 by [Andrew Dias](https://github.com/andrew-dias).
