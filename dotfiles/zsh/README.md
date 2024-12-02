# ZSH

## Installation

> [!NOTE]
>
> It is better to use the system native C toolchain to compile zsh from sources. Otherwise, the shell may be hanging in certain scenarios. E.g. with Clang 18 on Ubuntu a test was failing by just hanging the shell. With GCC on the same system everything worked fine.

[Download source distribution of zsh][zsh-download], unpack it, and open the terminal in the directory.

Alternatively, you can clone the sources:

```shell
git clone git://git.code.sf.net/p/zsh/code zsh
cd ./zsh
git checkout "${ZSH_VERSION}"
```

Install the build dependencies:

```shell
sudo apt update -y
sudo apt install -y \
  yodl \
  perl \
  info texinfo texinfo-lib install-info
```

> [!NOTE]
> If you checked the repo from git run `./Util/preconfig`. Otherwise, skip it.
>
> ```shell
> ./Util/preconfig
> ```

Configure the build:

```shell
mkdir ./build
../configure --enable-cflags="-O2"
```

Build and test:

```shell
make
make check
```

> [!NOTE]
>
> If something goes wrong with the build, run `make distclean` to remove everything that the `./configure` script generated.

After the build and tests successful completion, intsall zsh:

```shell
sudo make install
sudo make install.info
```

### Source `/etc/profile` from `/etc/zsh/zprofile`

> [!IMPORTANT]
>
> [`/etc/profile` file should be sourced by all POSIX sh-compatible shells upon login][arch-wiki-startup-shutdown-files].

```shell
sudo mkdir -p /etc/zsh
sudo echo ". /etc/profile" | sudo tee -a /etc/zsh/zprofile
```

### Set zsh as a default login shell

Ensure `zsh` is present in `/etc/shells`:

```shell
ZSH_PATH="$(which zsh)"; [[ -z "$(cat /etc/shells | grep "${ZSH_PATH}")" ]] && (echo "${ZSH_PATH}" | sudo tee -a /etc/shells) || echo "${ZSH_PATH} is already present in /etc/shells"
```

Set zsh as [default login shell][arch-wiki-change-default-shell]:

> [!NOTE]
>
> As per default PAM configuration, ensure that the shell you run this command from is listed in `/etc/shells`.

```shell
sudo chsh -s "$(which zsh)" "${USER}"
```

## Configuration

Setup config from this repo on your system:

```shell
./setup-config.sh
```

For a reference, see the [description of startup and shutdown files for zsh][arch-wiki-startup-shutdown-files]. Visally it looks as follows:

![Well-known shells startup and shutdown files](./img/shell-startup-actual.png)

### `antidote` plugin manager

#### [`antidote` installation][antidote-installation]

Clone the `antidote` sources:

```shell
git clone https://github.com/mattmc3/antidote.git ~/.antidote
cd ~/.antidote
git checkout "${ANTIDOTE_VERSION}"
```

Add the following to `.zshrc` (already present in this config):

```shell
## Antidote
### https://getantidote.github.io/install

ANTIDOTE_PATH="${HOME}/.antidote"

# Set the root name of the plugins files (.txt and .zsh) antidote will use.
zsh_plugins_txt="${ZDOTDIR:-~}/.zsh_plugins.txt"
zsh_plugins_zsh="${XDG_STATE_HOME}/.zsh_plugins.zsh"

# Ensure the .zsh_plugins.txt file exists so you can add plugins.
[[ -f "${zsh_plugins_txt}" ]] || touch "${zsh_plugins_txt}"

# Lazy-load antidote from its functions directory.
fpath=("${ANTIDOTE_PATH}/functions" ${fpath})
autoload -Uz antidote

# Generate a new static file whenever .zsh_plugins.txt is updated.
if [[ ! "${zsh_plugins_zsh}" -nt "${zsh_plugins_txt}" ]]; then
  antidote bundle <"${zsh_plugins_txt}" >|"${zsh_plugins_zsh}"
fi

# Source your static plugins file.
source "${zsh_plugins_zsh}"
```

### Prompt

#### Starship

Install [`../starship/README.md`](../starship/README.md) following the instructions.

Once you [installed starship on your system](../starship/README.md#installation), export its initialization code to a file that you will load from your `.zshrc`:

```shell
starship init "${SHELL##*/}" > "${ZSH_CUSTOM_PLUGINS_DIR}/starship_init"
```

This guide recommends that your rerun this command and overwrite the existing init file every time you update starship.

Then, make sure your `.zshrc` contains the following configuration:

```shell
[ -f "${ZSH_CUSTOM_PLUGINS_DIR}/starship_init" ] && source "${ZSH_CUSTOM_PLUGINS_DIR}/starship_init"
```

### Plugins

The [`antidote`](#antidote-plugin-manager) config in this repo installs the following plugins:

- [`zsh-vi-mode`](#zsh-vi-mode)
- [`fast-syntax-highlighting`](#fast-syntax-highlighting)
- [`zsh-autosuggestions`](#zsh-autosuggestions)
- [`zsh-completions`](https://github.com/zsh-users/zsh-completions/tree/master)
- [`rust-zsh-completions`](https://github.com/ryutok/rust-zsh-completions)
- [`fzf-tab`](#use-fzf-to-match-completions-via-fzf-tab)
- [`fzf-git`](#use-fzf-to-search-for-git-objects-via-fzf-git)

Install new plugins with [`antidote`](#antidote-plugin-manager) (see the full list of [options][antidote-options]):

```shell
antidote install <plugin-url> [options]
```

`antidote` will add the given plugin to the [`./config/zsh/.zsh_plugins.txt`](./config/zsh/.zsh_plugins.txt) file.

Additionally, see the [Integrations](#integrations) section to setup zsh to work with other tools.

#### `zsh-vi-mode`

[Configuration & default keybindings docs][github-zsh-vi-mode].

> [!NOTE]
>
> This guide recommends to use `ZVM_INIT_MODE=sourcing`. You should setup custom keybindings with `zvm_after_init_commands` and `zvm_after_lazy_keybindings_commands` respoctively. Additionally, you should initialize this plugin before [fzf integration](#fzf), [`fzf-tab`](#use-fzf-to-match-completions-via-fzf-tab), and [`zsh-autosuggestions`](#zsh-autosuggestions). The guide recommends to initialize thees plugins in the specified order after the `zsh-vi-mode` directly in `.zshrc` file. Do not use `zvm_after_init_commands` to initialize these plugins.

#### `fast-syntax-highlighting`

> [!NOTE]
>
> This guide recommends to install [`fast-syntax-highlighting`][fast-syntax-highlighting] manually to have a control for ordering when `.zshrc` sources it. You should source this plugin at the end of `.zshrc`, after [`fzf-tab`](#use-fzf-to-match-completions-via-fzf-tab) and before [`zsh-autosuggestion`](#zsh-autosuggestions) if you use it.

```shell
mkdir -p "${ZSH_CUSTOM_PLUGINS_DIR}/fast-syntax-hihlighting"
git clone git@github.com:zdharma-continuum/fast-syntax-highlighting "${ZSH_CUSTOM_PLUGINS_DIR}/fast-syntax-highlighting"
cd "${ZSH_CUSTOM_PLUGINS_DIR}/fast-syntax-highlighting"
git checkout "${FAST_SYNTAX_HIGHLIGHTING_COMMIT_ID}"
```

Then, make sure your `.zshrc` contains the following configuration:

```shell
[ -f "${ZSH_CUSTOM_PLUGINS_DIR}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ] && source "${ZSH_CUSTOM_PLUGINS_DIR}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
```

> [!NOTE]
>
> If you use:
> - [`zsh-vi-mode`](#zsh-vi-mode), source `fast-syntax-highlighting` after it.
> - [`fzf-tab`](#use-fzf-to-match-completions-via-fzf-tab), source `fast-syntax-highlighting` after it.
> - [`zsh-autosuggestion`](#zsh-autosuggestions), source `fast-syntax-highlighting` before it.

#### `zsh-syntax-highlighting`

❌Not recommended. Use [`fast-syntax-highlighting`](#fast-syntax-highlighting) instead.❌

> [!WARNING]
>
> This guide does not recommend to use `zsh-syntax-highlighting` due to incompatibility with [`zsh-vi-mode`](#zsh-vi-mode). For more details see this issue: https://github.com/zsh-users/zsh-syntax-highlighting/issues/871

#####  `zsh-syntax-highlighting` installation

> [!NOTE]
>
> If you decide to to install [`zsh-syntax-highlighting`][github-zsh-syntax-highlighting], the guide recommends that you do this manually, because it should be sourced at the end of `.zshrc`.

```shell
mkdir -p "${ZSH_CUSTOM_PLUGINS_DIR}/zsh-syntax-highlighting"
git clone --branch "${ZSH_SYNTAX_HIGHLIGHTING_VERSION}" git@github.com:zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM_PLUGINS_DIR}/zsh-syntax-highlighting"
```

Then, make sure your `.zshrc` contains the following configuration:

```shell
[ -f "${ZSH_CUSTOM_PLUGINS_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "${ZSH_CUSTOM_PLUGINS_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
```

#### `zsh-autosuggestions`

##### `zsh-autosuggestions` installation

> [!NOTE]
>
> This guide recommends to install [`zsh-autosuggestions`][zsh-autosuggestions] manually to have a control for ordering when `.zshrc` sources it. You should source this plugin at the end of `.zshrc`.

```shell
mkdir -p "${ZSH_CUSTOM_PLUGINS_DIR}/zsh-autosuggestions"
git clone --branch "${ZSH_AUTOSUGGESTIONS_VERSION}" git@github.com:zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM_PLUGINS_DIR}/zsh-autosuggestions"
```

Then, make sure your `.zshrc` contains the following configuration:

```shell
[ -f "${ZSH_CUSTOM_PLUGINS_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "${ZSH_CUSTOM_PLUGINS_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh"
```

> [!NOTE]
>
> If you use [`zsh-syntax-highlighting`](#zsh-syntax-highlighting) or [`fast-syntax-highlighting`](#fast-syntax-highlighting), source `zsh-autosuggestions` after it.

### Integrations

#### `fzf`

Before proceeding, [ensure that you have `fzf` installed on your system](../terminal-utils/fzf/README.md#installation).

##### `fzf` shell integration for zsh

> [!NOTE]
>
> For security reasons, this guide recommends to statically save the integration script to a file that you will load from your `.zshrc`. This also means that it is best to use `fzf` to update this script every time you update `fzf`.

```shell
fzf "--${SHELL##*/}" > "${ZSH_CUSTOM_PLUGINS_DIR}/fzf-integration.zsh"
```

Then, make sure your `.zshrc` contains the following configuration:

```shell
[ -f "${ZSH_CUSTOM_PLUGINS_DIR}/fzf-integration.zsh" ] && source "${ZSH_CUSTOM_PLUGINS_DIR}/fzf-integration.zsh" 
```

After you set up the integration, you can use the [following keys to use `fzf` to peform common tasks in the interactive shell][fzf-shell-integration] (in the default configuration):

- `CTRL-T` - opens a prompt where the user can search and select files under the current working directory. After the confirmation, the shell integration will **insert the selected files in the current command**.
- `ALT-C` - opens a prompt where the user can search and select directories under the current working directory. After the confirmation, the shell integration will **change the current working directory to the selected one**.
- `CRTL-R` - opens a prompt where the user can search the command history. After the configmation, the shell integration will insert the selected command in the current prompt.

##### Use `fzf` to match completions via `fzf-tab`

###### `fzf-tab` installation

> [!NOTE]
>
> This guide recommends to install `fzf-tab` manually, because it must be sourced after the `compinit` but before plugins that wrap widgets (e.g. [`zsh-autosuggestion`](#zsh-autosuggestion)).

```shell
mkdir -p "${ZSH_CUSTOM_PLUGINS_DIR}/fzf-tab"
git clone --branch "${ZSH_FZF_TAB_VERSION}" git@github.com:Aloxaf/fzf-tab.git "${ZSH_CUSTOM_PLUGINS_DIR}/fzf-tab"
```

> [!IMPORTANT]
>
> Make sure you source the plugin after `compinit`, but before [`zsh-autosuggestions`](#zsh-autosuggestions).

Then, make sure your `.zshrc` contains the following configuration after `compinit`, but before [`zsh-autosuggestions`](#zsh-autosuggestions):

```shell
[ -f "${ZSH_CUSTOM_PLUGINS_DIR}/fzf-tab/fzf-tab.plugin.zsh" ] && source "${ZSH_CUSTOM_PLUGINS_DIR}/fzf-tab/fzf-tab.plugin.zsh"
```

- [ ] TODO?
    - ```shell
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color "${realpath}"'
      ```

##### Use `fzf` to search for git objects via `fzf-git`

###### `fzf-git` installation

This guide recommends to install [fzf-git][#github-fzf-git] with a [plugin manager](antidote-plugin-manager).

#### `ripgrep`

Before proceeding, [ensure that you have `ripgrep` installed on your system](../terminal-utils/ripgrep/README.md#installation).

##### `ripgrep` shell completions

Use `ripgrep` to generate completions for zsh:

```shell
rg --generate "complete-${SHELL##*/}" > "${ZSH_COMPLETIONS_DIR}/_rg"
```

After you generated the completions, ensure that the directory with the `_rg` completions file is on your zsh `fpath`.

#### `eza`

Before proceeding, [ensure that you have `eza` installed on your system](../terminal-utils/eza/README.md#installation).

##### `eza` shell completions

Clone the eza repo locally:

```shell
git clone git@github.com:eza-community/eza.git
cd eza
git checkout "${EZA_VERSION}"
```

Use `eza` to generate completions for zsh:

```shell
cp "$(pwd)/completions/zsh/_eza" "${ZSH_COMPLETIONS_DIR}/_eza"
sed 's/__eza/_eza/g' --in-place "${ZSH_COMPLETIONS_DIR}/_eza"
```

#### `zoxide`

Before proceeding, [ensure that you have `zoxide` installed on your system](../terminal-utils/zoxide/README.md#installation).

##### `zoxide` shell integration

> [!NOTE]
>
> For security reasons, this guide recommends to statically save the integration script to a file that you will load from your `.zshrc`. This also means that it is best to use `zoxide` to update this script every time you update `zoxide`.

If you want to configure `zoxide`, set the environment variables before running the following command. If you want to reconfigure `zoxide` - set the envs and rerun the commands.

```shell
zoxide init "${SHELL##*/}" > "${ZSH_CUSTOM_PLUGINS_DIR}/zoxide-integration.zsh"
```

Then, make sure your `.zshrc` contains the following configuration **after the `compinit`**:

```shell
[ -f "${ZSH_CUSTOM_PLUGINS_DIR}/zoxide-integration.zsh" ] && source "${ZSH_CUSTOM_PLUGINS_DIR}/zoxide-integration.zsh"
```

> [!NOTE]
>
> For completions to work, the above line must be added after compinit is called. You may have to rebuild your completions cache by running `rm ~/.zcompdump*; compinit`.

#### `bat`

##### `bat` completions

This guide assumes you followed the [instructions from this repo and inslled `bat` from sources](../terminal-utils/bat/README.md#installation). After the build, the target directory should now have the completions script. Copy it to where you install custom completions (`$ZSH_COMPLETIONS_DIR` in this guide):

```shell
cp ./target/release/build/bat-*/**/completions/bat."${SHELL##*/}" "${ZSH_COMPLETIONS_DIR}/_bat"
```

##### `bat-extras` completions

Unfortunately, [`bat-extras`](../terminal-utils/bat/README.nd#install-bat-extras) does not come with the completions. The best effort that the user can do to enable the completions is to configure zsh to use completions for the commands that `bat-extras` wrap. Add the following after `compinit`:

```shell
compdef batdiff=diff
compdef batwatch=watch
compdef batgrep=rg
```

> [!NOTE]
>
> This method may still not enable completions for some `bat-extras` commands.

#### `delta`

##### `delta` completions

[Use `delta` to generate completions for zsh](https://dandavison.github.io/delta/tips-and-tricks/shell-completion.html):

```shell
delta --generate-completion "${SHELL##*/}" > "${ZSH_COMPLETIONS_DIR}/_delta"
```

### Benchmarking

This guide recommends using [`zsh-bench`][github-zsh-bench] to benchmark the shell performance. Follow the instructions from the project's README to measure the performance you a zsh setup and to understand how to improve it.

- TODO: zprof
  - Beginning `zmodload zsh/zprof`
  - End `zprof`
  - Optimization with `zcompile` inspired by diy++

## Useful links

- [arch-wiki-change-default-shell][arch-wiki-change-default-shell]
- [arch-wiki-startup-shutdown-files][arch-wiki-startup-shutdown-files]
- [zsh-org][zsh-org]
  - [zsh-download][zsh-download]
  - Docs
    - [zsh-intro-doc][zsh-intro-doc]
    - [zsh-faq][zsh-faq]
    - [zsh-manual-toc][zsh-manual-toc]
      - [zsh-options][zsh-options]
    - [zsh-user-guide-toc][zsh-user-guide-toc]
- [youtube-zsh-dream-of-autonomy][youtube-zsh-dream-of-autonomy]
- [antidote-installation][antidote-installation]
- [antidote-options][antidote-options]
- [github-zsh-vi-mode][github-zsh-vi-mode]
- [github-fast-syntax-highlighting][github-fast-syntax-highlighting]
- [github-zsh-syntax-highlighting][github-zsh-syntax-highlighting]
- [github-zsh-autosuggestions][github-zsh-autosuggestions]
- [github-zsh-bench][github-zsh-bench]
- [fzf-shell-integration][fzf-shell-integration]
- [github-fzf-tab][github-fzf-tab]
- [github-fzf-git][github-fzf-git]

[arch-wiki-change-default-shell]: <https://wiki.archlinux.org/title/Command-line_shell#Changing_your_default_shell>
[arch-wiki-startup-shutdown-files]: <https://wiki.archlinux.org/title/Zsh#Startup/Shutdown_files>
[zsh-org]: <https://www.zsh.org/>
[zsh-download]: <https://zsh.sourceforge.io/Arc/source.html>
[zsh-intro-doc]: <https://zsh.sourceforge.io/Intro/intro_toc.html>
[zsh-faq]: <https://zsh.sourceforge.io/FAQ/>
[zsh-manual-toc]: <https://zsh.sourceforge.io/Doc/Release/zsh_toc.html>
[zsh-options]: <https://zsh.sourceforge.io/Doc/Release/Options.html>
[zsh-user-guide-toc]: <https://zsh.sourceforge.io/Guide/zshguide.html>
[youtube-zsh-dream-of-autonomy]: <https://www.youtube.com/watch?v=ud7YxC33Z3w>
[antidote-installation]: <https://getantidote.github.io/install>
[antidote-options]: <https://getantidote.github.io/options>
[github-zsh-vi-mode]: <https://github.com/jeffreytse/zsh-vi-mode>
[github-fast-syntax-highlighting]: <https://github.com/zdharma-continuum/fast-syntax-highlighting>
[github-zsh-syntax-highlighting]: <https://github.com/zsh-users/zsh-syntax-highlighting>
[github-zsh-autosuggestions]: <https://github.com/zsh-users/zsh-autosuggestions>
[github-zsh-bench]: <https://github.com/romkatv/zsh-bench>
[fzf-shell-integration]: <https://junegunn.github.io/fzf/shell-integration/>
[github-fzf-tab]: <https://github.com/Aloxaf/fzf-tab>
[github-fzf-git]: <https://github.com/junegunn/fzf-git.sh>
