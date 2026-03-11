# 🐍 Python Development Workflow

The Python configuration (`lisp/lang-python.el`) provides a robust, modern IDE experience centered around high-performance tools.

---

## ✨ Features

- **Language Server Protocol**: Deep integration with `pyright` via Emacs' native `eglot`.
- **Ultra-Fast Formatting**: Automated formatting using `ruff`, seamlessly running before every save.
- **Virtual Environment Support**: Effortless toggling between project dependencies using `pyvenv`.
- **Syntax Highlighting**: AST-based precision highlighting via `python-ts-mode`.

---

## 📦 Prerequisites

To enable all features, ensure the following CLI tools are available in your `PATH`:

```bash
# Install Pyright for type-checking and Ruff for linting/formatting
pip install pyright ruff
```

---

## ⌨️ Daily Workflow & Keybindings

### 1. Managing Virtual Environments
Before starting work on a project, activate its virtual environment:
- Run `M-x pyvenv-activate` and provide the path to your `.venv` directory.
- *Tip*: Emacs will automatically update the LSP context when the environment changes.

### 2. Coding & Formatting
- **Auto-format**: Simply save the file (`C-x C-s`). Ruff will format the code instantaneously.
- **Manual format**: If you need to trigger it manually, run `M-x my-python-format-buffer`.

### 3. Interactive REPL
Send code to an interactive Python shell for quick testing:
| Shortcut | Action |
| :--- | :--- |
| `C-c C-z` | Open or switch to the Python REPL. |

---

## ⚙️ Under the Hood

- **`python-ts-mode`**: We automatically remap standard `python-mode` to the tree-sitter backed `python-ts-mode` if the grammar is installed.
- **Eglot**: Connects to `pyright-langserver --stdio`.
