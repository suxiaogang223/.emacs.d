# My Minimalist Emacs

Minimal Emacs configuration with a small modular layout.

## Structure

- [`init.el`](/Users/suxiaogang/.emacs.d/init.el): thin entrypoint that loads modules
- [`lisp/init-package.el`](/Users/suxiaogang/.emacs.d/lisp/init-package.el): package bootstrap and missing-package recovery
- [`lisp/init-completion.el`](/Users/suxiaogang/.emacs.d/lisp/init-completion.el): minibuffer completion UI
- [`lisp/init-editing.el`](/Users/suxiaogang/.emacs.d/lisp/init-editing.el): shared editing behavior
- [`lisp/init-tools.el`](/Users/suxiaogang/.emacs.d/lisp/init-tools.el): proxy, `company`, `eglot`, `eldoc`
- [`lisp/init-ui.el`](/Users/suxiaogang/.emacs.d/lisp/init-ui.el): UI and theme behavior
- [`lisp/lang-*.el`](/Users/suxiaogang/.emacs.d/lisp): language-specific configuration

## Completion stack

- `vertico`: minibuffer candidate UI
- `marginalia`: richer annotations
- `orderless`: flexible matching
- `consult`: search and navigation commands

Common bindings:

- `C-s`: `consult-line`
- `C-x b`: `consult-buffer`
- `M-y`: `consult-yank-pop`
- `M-g g`: `consult-goto-line`
- `M-g i`: `consult-imenu`

## Package install behavior

On startup, Emacs checks `package-selected-packages` and only tries to install packages that are missing locally.
If package download fails, startup continues and emits a warning instead of aborting.

Useful commands:

- `M-x my-missing-selected-packages`: show which selected packages are still missing
- `M-x my-bootstrap-packages`: refresh archives and install all missing selected packages

## New machine setup

1. Start Emacs once.
2. If packages were not installed automatically, run `M-x my-bootstrap-packages`.
3. Install external language tools as needed:
   - Python: `uv tool install pyright ruff`
   - C/C++: install `clangd`
   - Rust: install `rust-analyzer`

## Notes

- Python tree-sitter grammar can be installed with `M-x my-install-python-treesit-grammar`.
- Python virtual environments can be activated with `M-x pyvenv-activate`.
- C/C++ tree-sitter grammars can be installed with `M-x my-install-c/c++-treesit-grammars`.
- Rust tree-sitter grammar can be installed with `M-x my-install-rust-treesit-grammar`.
- C/C++ uses `clangd` and `clang-format`; Rust uses `rust-analyzer`, `cargo`, and `rustfmt`.
- Racket uses `racket-mode` with `racket-xp-mode`, `racket-run`, `racket-test`, and `racket-repl`.
- C/C++ detects `Makefile` and common CMake build directories to set `compile-command`.
- C/C++ passes `--compile-commands-dir` to `clangd` when `compile_commands.json` is found under the project or a common build directory.
- For CMake projects without a build directory yet, `compile-command` defaults to configure with `CMAKE_EXPORT_COMPILE_COMMANDS=ON` and then build.
- Racket adds shortcuts for docs, profile, and switching between source and REPL.
