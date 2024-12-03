# Starship

> [!NOTE] **Deprecation reason**
>
> After [measuring zsh performance with `zsh-bench`](../../zsh/README.md#benchmarking), it turned out that starship made the shell noticeably slower than it should be. Instead, this guide recommends setting up the [pure prompt](../../zsh/README.md#pure-prompt).

## Installation

> [!NOTE]
>
> Ensure you have the following language toolhcains:
> - [Rust](../system-setup/toolchains/rust/README.md).
>
> [You can verify the versions of the installed toolcahins with the script](../system-setup/toolchains/README.md#verify-versions-of-the-installed-toolchains).

> [!NOTE]
>
> Additionally, ensure that you have [Nerd Fonts](../system-setup/fonts.md#nerd-fonts) installed and cloned on your system.

This guide recommends installing `starship` with `cargo`:

```shell
cargo install starship --locked
```

### Install completions

#### zsh

Assuming you store your zsh completions in `${ZSH_COMPLETIONS_DIR}` and it is in your `${fpath}`, the following command will enable zsh completions:

```shell
source <(starship completions zsh | tee "${ZSH_COMPLETIONS_DIR}/_starship")
```

### Enable starship as your shell prompt

For security reasons it is recommended to save the output of `starship init "${SHELL##*/}"` to a file and source it from the shell rc file. This guide recommends that your rerun this command and overwrite the existing init file every time you update starship.

To enable it for zsh see [this doc](../zsh/README.md#starship).

## Configuration

- TODO

## Useful links

- [starship][starship]

[starship]: <https://starship.rs>
