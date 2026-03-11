# ❄️ C/C++ Development Workflow

The C/C++ configuration (`lisp/lang-cc.el`) is built to handle complex codebases by deeply integrating with modern tools like `clangd` and `CMake`.

---

## ✨ Features

- **Advanced LSP Intelligence**: Powered by `clangd` for highly accurate completions, cross-referencing, and refactoring.
- **Smart Build System Detection**: Automatically locates `compile_commands.json` in common build directories (e.g., `build/`, `out/`).
- **Zero-Config CMake Setup**: Automatically generates compilation databases for fresh CMake projects.
- **Automated Formatting**: Integrates `clang-format` on save.

---

## 📦 Prerequisites

You need the LLVM toolchain installed on your system:

```bash
# macOS
brew install llvm

# Ubuntu/Debian
sudo apt install clangd clang-format
```
*Ensure `clangd` and `clang-format` are available in your system `PATH`.*

---

## ⌨️ Daily Workflow & Keybindings

### Intelligent Compilation Setup
When you open a C/C++ file, Emacs attempts to configure the `compile-command`:
1. It searches for `Makefile`.
2. It looks for CMake build directories (`build/`, `out/`).
3. If it finds a root `CMakeLists.txt` but no build directory, it configures the compile command to:
   `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -B build && cmake --build build`

### Formatting
- Files are automatically formatted via `clang-format` every time you save.
- Ensure you have a `.clang-format` file in your project root to dictate the style rules.

---

## ⚙️ Under the Hood

- **`eglot` and `clangd`**: We pass `--compile-commands-dir` to `clangd` dynamically when a build directory is found, ensuring the language server fully understands your project's include paths and macros.
- **Tree-sitter**: Run `M-x my-install-c/c++-treesit-grammars` to install grammars for both C and C++ for pixel-perfect syntax highlighting.
