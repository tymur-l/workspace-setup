# Dotfiles

Configuration and setup instructions for the commonly used customized software.

> [!NOTE]
>
> To install some of the software listed here, users may require the following language toolhcains:
> - [C/C++](../system-setup/toolchains/llvm/README.md).
> - [Python](../system-setup/toolchains/python/README.md).
> - [Go](../system-setup/toolchains/go/README.md).
> - [Rust](../system-setup/toolchains/rust/README.md).
>
> [You can verify the versions of the installed toolcahins with the script](../system-setup/toolchains/README.md#verify-versions-of-the-installed-toolchains).

## Software

- In progress
  - [Kitty](./kitty/README.md).
  - [`neovim`](./neovim/README.md).
  - [zsh](./zsh/README.md).
  - [tmux](./tmux/README.md).
  - [Terminal utils](./terminal-utils/README.md).
- TODO
  - Hyperland.
  - ollama.
    - Code suggestions in text editors (perhaps using codellama).
      - Consider sourcegraph's Cody for text editor integration.
  - Make this setup (or a part of it) into a nix package.

### Deprecated

The subtree under the [`./deprecated/`](./deprecated/) directory consists of the software that the setup used previously, but decided to abandon using it. Therefore, this guide does not recommend setting this software up as a part of this setup.

<!--

### `home-manager`

Source: https://github.com/nix-community/home-manager
Docs: https://nix-community.github.io/home-manager/

-->
