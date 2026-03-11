# 📖 Minimalist Emacs Documentation

Welcome to the official documentation for my personal Emacs configuration. This site provides in-depth guides on how the configuration is structured, how to install it, and how to maximize your productivity for various programming languages.

## 🎯 The Vision

This configuration is built for **speed, simplicity, and modern engineering**. 
Rather than relying on heavy, monolithic frameworks (like Spacemacs or Doom Emacs), this setup is crafted from the ground up to be:
- **Transparent**: You can read and understand every line of `init.el` and the `lisp/` modules.
- **Modern**: Heavily utilizes Emacs 29/30 built-in features like `eglot` (LSP) and `tree-sitter` (Syntax Highlighting).
- **Aesthetic**: Minimal UI elements, maximizing screen real estate for your code.

---

## 📚 Table of Contents

### 1. Fundamentals
* **[Setup & Installation](setup.md)**: System requirements, dependencies, and bootstrapping.

### 2. Language Workflows
Discover how to utilize the tailored development environments:
* **[🐍 Python](lang-python.md)**: Pyright, Ruff, and Pyvenv.
* **[🦀 Rust](lang-rust.md)**: rust-analyzer, Cargo integration.
* **[❄️ C/C++](lang-cc.md)**: Clangd, CMake, and Makefile support.
* **[🎾 Racket](lang-racket.md)**: racket-mode, REPL, and rackunit.

---

## 🤝 Getting Help

If you encounter any issues:
1. Run `M-x my-bootstrap-packages` to ensure all packages are correctly installed.
2. Check the `*Messages*` buffer for any warnings or errors.
3. Verify that your language servers (LSP) are installed and accessible in your system's `PATH`.
