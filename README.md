# ansible-role-dev-machine

This [Ansible](https://github.com/ansible/ansible) role configures my [Pop_OS!](https://system76.com/pop) 18.04 development machine, including applications, OS configuration, and dotfiles.

The role includes:

- SSH

  - Generate new SSH keypair for `user@machine` and register with Github and Gitlab

- Shell config & desktop environment stuff

  - [Zsh](http://zsh.sourceforge.net) with configuration, plugins and colour settings
  - [Gnome extensions](https://github.com/andrew-dias/ansible-gnome-extensions)
  - [XDG](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) spec folders
  - [pip](https://pypi.org/project/pip/)
  - dconf-editor
  - Fonts
  - Dotfiles and shell scripts

- General apps

  - [Google Chrome](https://www.google.com/chrome)
  - [Spotify](https://www.spotify.com)
  - [Flameshot](https://flameshot.js.org/#/)
  - [Gufw](https://help.ubuntu.com/community/Gufw)

- Communication

  - [Mattermost](https://mattermost.com/)

- Dev tools
  - [Node Version Manager](https://github.com/creationix/nvm) and desired node versions
  - [SDKMAN!](https://sdkman.io)
  - [Neovim](https://neovim.io) with configuration and plugins
  - [Tmux](https://github.com/tmux/tmux) with configuration
  - [Tmuxinator](https://github.com/tmuxinator/tmuxinator)
  - [jq](https://stedolan.github.io/jq)
  - [Visual Studio Code](https://code.visualstudio.com)
  - [Gitkraken](https://www.gitkraken.com)
  - [Postman](https://www.getpostman.com)
  - [Jetbrains Toolbox](https://www.jetbrains.com/toolbox)
  - [Docker CE](https://www.docker.com)
  - [OpenShift CLI](https://www.okd.io/download.html)
  - [VirtualBox](https://www.virtualbox.org)
  - [Vagrant](https://www.vagrantup.com)

## Role Variables

XDG: The role assumes the usage of the default [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) locations for user config, data and cache folders:

| Variable              | Default Value        |
| --------------------- | -------------------- |
| `xdg.XDG_CACHE_HOME`  | `$HOME/.cache`       |
| `xdg.XDG_CONFIG_HOME` | `$HOME/.config`      |
| `xdg.XDG_DATA_HOME`   | `$HOME/.local/share` |

ZSH:

| Variable     | Default Value                         |
| ------------ | ------------------------------------- |
| `zsh.zshenv` | `/etc/zsh/zshenv`                     |
| `zsh.fpath`  | `/usr/local/share/zsh/site-functions` |

SDKMAN!

| Variable              | Default Value           |
| --------------------- | ----------------------- |
| `sdkman.download_url` | `https://get.sdkman.io` |

Node:

| Variable           | Default Value                                      |
| ------------------ | -------------------------------------------------- |
| `nvm.download_url` | `https://raw.githubusercontent.com/creationix/nvm` |
| `nvm.version`      | `0.35.1`                                           |
| `node.versions`    | `[10, 8]`                                          |

Tmuxinator

| Variable                        | Default Value                                                                              |
| ------------------------------- | ------------------------------------------------------------------------------------------ |
| `tmuxinator.zsh_completion_url` | `https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh` |

SSH keys will be generated and uploaded to Github and Gitlab:

| Variable              | Default Value |
| --------------------- | ------------- |
| `ssh.passphrase`      | `empty`       |
| `ssh.github_username` | `empty`       |
| `ssh.github_token`    | `empty`       |
| `ssh.gitlab_host`     | `empty`       |
| `ssh.gitlab_token`    | `empty`       |

GitKraken

| Variable                 | Default Value                                          |
| ------------------------ | ------------------------------------------------------ |
| `gitkraken.download_url` | `https://release.axocdn.com/linux/gitkraken-amd64.deb` |

Ansible Toolbox

| Variable                       | Default Value                                   |
| ------------------------------ | ----------------------------------------------- |
| `ansible_toolbox.download_url` | `git+https://github.com/larsks/ansible-toolbox` |

Docker:

| Variable                         | Default Value                                                           |
| -------------------------------- | ----------------------------------------------------------------------- |
| `docker.credentials_archive_url` | `https://github.com/docker/docker-credential-helpers/releases/download` |
| `docker.credentials_version`     | `0.6.3`                                                                 |

OpenShift:

| Variable                    | Default Value                                               |
| --------------------------- | ----------------------------------------------------------- |
| `openshift.oc_archive_name` | `openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit` |
| `openshift.oc_archive_url`  | `https://github.com/openshift/origin/releases/download`     |
| `openshift.oc_version`      | `3.11.0`                                                    |

Fonts

| Variable | Default Value                                                                      |
| -------- | ---------------------------------------------------------------------------------- |
| fonts    | [[hasklig](https://github.com/i-tu/Hasklig/releases/download/1.1/Hasklig-1.1.zip)] |

## Pre-Install Steps

- Install JMESPath (required for [Jetbrains Toolbox](https://github.com/jaredhocutt/ansible-jetbrains-toolbox#requirements) role).

  ```
  $ sudo apt install python-jmespath
  ```

## Example Playbook

```
- hosts: localhost
  roles:
    andrew-dias.ansible-role-dev-machine

  # optionally prompt for ssh key passphrase
  - vars_prompt:
    - name: "ssh_key_passphrase"
      prompt: "Enter SSH key passphrase"
      private: yes
```

## Post-Run/Manual Steps

Once completed, you should:

1. Log out to ensure all changes are activated
1. Open a terminal and choose your colour theme by typing `base16` followed by a tab to perform tab completion.

## Dependencies

- `cmprescott.chrome`
- `jaredhocutt.jetbrains_toolbox`
- `geerlingguy.docker`
- `https://github.com/andrew-dias/ansible-role-vagrant`
- `https://github.com/andrew-dias/ansible-role-virtualbox`
- `https://github.com/andrew-dias/ansible-gnome-extensions`

## License

MIT

## Author Information

This role was created in 2019 by [Andrew Dias](https://github.com/andrew-dias).
