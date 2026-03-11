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
| `C-c C-f` | `rust-format-buffer` | Format the current file (`rustfmt`). *Also runs automatically on save.* |
| `C-c C-k` | `rust-check` | Run `cargo check` across the workspace. |
| `C-c C-c` | `rust-compile` | Standard compile / build command. |
| `C-c C-b` | `rust-compile-release`| Build project with `--release` flag. |
| `C-c C-r` | `rust-run` | Run the project (`cargo run`). |
| `C-c C-t` | `rust-test` | Run the test suite (`cargo test`). |
| `C-c C-l` | `rust-run-clippy` | Run the linter (`cargo clippy`). |
| `C-c C-d` | `my-rust-doc` | Generate and open offline crate documentation. |

---

## ⚙️ Under the Hood

- **`project.el` Integration**: Functions like `my-rust-project-root` hook into `project.el` to accurately locate your `Cargo.toml`, ensuring commands are executed from the correct directory.
- **Tree-sitter**: Run `M-x my-install-rust-treesit-grammar` to enable `rust-ts-mode`.
