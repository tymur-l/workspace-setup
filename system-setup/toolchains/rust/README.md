# Rust

## Installation

Download `rustup-init` for your system from [the official website](https://forge.rust-lang.org/infra/other-installation-methods.html#other-ways-to-install-rustup).

Run the interactive installer. Follow the instructions and setup the latest stable version of `rustc`, `cargo`, and `rustup` on your machine:

```shell
./rustup-init
```

### zsh completions

If you use [zsh](../dotfiles/zsh/README.md) your should install the [rust-zsh-completions][rust-zsh-completions]. See the [docs from this repo](../dotfiles/zsh/README.md#plugins) for more details.

### Updating

```shell
rustup update
```

## Useful links

- [rust-get-started][rust-get-started]
- [the-rust-book][the-rust-book]
- [the-rust-book-interactive][the-rust-book-interactive]
- [the-cargo-book][the-cargo-book]

[rust-get-started]: <https://www.rust-lang.org/learn/get-started>
[the-rust-book]: <https://doc.rust-lang.org/book/>
[the-rust-book-interactive]: <https://rust-book.cs.brown.edu/>
[the-cargo-book]: <https://doc.rust-lang.org/cargo/>
[rust-zsh-completions]: <https://github.com/ryutok/rust-zsh-completions>