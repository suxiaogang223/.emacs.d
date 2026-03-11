# 🦀 Rust Development Workflow

The Rust configuration (`lisp/lang-rust.el`) is engineered for seamless interaction with the Cargo ecosystem, providing context-aware commands and deep language intelligence.

---

## ✨ Features

- **Context-Aware Building**: Emacs intelligently guesses your build target (`check`, `test`, `run`, `bench`) based on the current file's directory.
- **LSP Integration**: Native `eglot` support paired with `rust-analyzer` for inline hints, macro expansion, and refactoring.
- **Tree-sitter Native**: Full support for `rust-ts-mode`.

---

## 📦 Prerequisites

You need the standard Rust toolchain installed via `rustup`:

```bash
# Install Rust, Cargo, and formatting tools
rustup default stable
rustup component add rust-analyzer rustfmt clippy
```

---

## ⌨️ Daily Workflow & Keybindings

### Context-Aware Compilation
Press `M-x compile` (or your custom compile binding). The command dynamically adapts:
- Editing `tests/integration.rs` ➔ `cargo test --test integration`
- Editing `examples/demo.rs` ➔ `cargo run --example demo`
- Editing `benches/speed.rs` ➔ `cargo bench --bench speed`
- Editing `src/main.rs` ➔ `cargo check`

### Rust Shortcuts

| Shortcut | Command | Action |
| :--- | :--- | :--- |
| `C-c C-f` | `my-rust-format-buffer` | Format the current file with `rustfmt`. Also runs automatically on save. |
| `C-c C-k` | `my-rust-check` | Run `cargo check` across the workspace. |
| `C-c C-c` | `my-rust-compile` | Run the current buffer's `compile-command`. |
| `C-c C-b` | `my-rust-compile-release`| Build the project with `cargo build --release`. |
| `C-c C-r` | `my-rust-run` | Run the project with `cargo run`. |
| `C-c C-e` | `my-rust-run-release` | Run the project with `cargo run --release`. |
| `C-c C-t` | `my-rust-test` | Run the test suite with `cargo test`. |
| `C-c C-l` | `my-rust-run-clippy` | Run the linter with `cargo clippy`. |
| `C-c C-d` | `my-rust-doc` | Build crate documentation with `cargo doc --no-deps`. |

---

## ⚙️ Under the Hood

- **`project.el` Integration**: Functions like `my-rust-project-root` hook into `project.el` to accurately locate your `Cargo.toml`, ensuring commands are executed from the correct directory.
- **Tree-sitter**: Run `M-x my-install-rust-treesit-grammar` to enable `rust-ts-mode`.
