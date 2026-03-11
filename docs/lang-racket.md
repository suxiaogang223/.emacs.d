# 🎾 Racket Development Workflow

The Racket configuration (`lisp/lang-racket.el`) transforms Emacs into a powerful, interactive Lisp machine for Racket development, rivaling DrRacket.

---

## ✨ Features

- **Deep Integration**: Powered by the excellent `racket-mode`.
- **Interactive REPL**: Send code directly to a running Racket process.
- **Symbol Exploration**: Real-time cross-referencing and jump-to-definition via `racket-xp-mode`.
- **Testing**: Built-in support for running `rackunit` tests directly from the buffer.

---

## 📦 Prerequisites

Ensure Racket is installed and the `racket` and `raco` executables are in your system `PATH`.

```bash
# macOS
brew install --cask racket
```

---

## ⌨️ Daily Workflow & Keybindings

`racket-mode` provides an exceptional set of interactive commands.

| Shortcut | Command | Action |
| :--- | :--- | :--- |
| `C-c C-z` | `racket-repl` | Open or switch to the Racket REPL. |
| `C-c C-r` | `racket-run` | Run the current file. |
| `C-c C-t` | `racket-test` | Execute `rackunit` test submodules. |
| `C-c C-d` | `racket-xp-documentation` | Open local Racket documentation for the symbol at point. |
| `C-c C-s` | `racket-documentation-search` | Search the Racket documentation. |
| `C-c C-p` | `racket-profile` | Profile the current program. |
| `M-n` | `racket-xp-next-error` | Jump to the next analysis error. |
| `M-p` | `racket-xp-previous-error` | Jump to the previous analysis error. |

### Advanced Symbol Exploration (`racket-xp-mode`)
When you open a Racket file, `racket-xp-mode` is activated automatically.
- **Hover**: Move your cursor over any identifier to see its binding structure.
- **Navigation**: It acts as a lightweight language server, providing immediate feedback on syntax errors and variable scope without needing external LSP infrastructure.
