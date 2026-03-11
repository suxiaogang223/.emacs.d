# Repository Guidelines

## Project Structure & Module Organization

This repository is an Emacs configuration, not an application library. `init.el` is the thin entrypoint that loads modules from `lisp/`. Shared behavior lives in `init-*.el` files such as `init-package.el`, `init-tools.el`, and `init-ui.el`. Language-specific setup lives in `lang-*.el` files such as `lang-python.el`, `lang-cc.el`, and `lang-rust.el`. Runtime directories like `elpa/`, `transient/`, `eshell/`, and `tree-sitter/` are local state, not source.

## Build, Test, and Development Commands

- `emacs --batch -Q -l init.el`: smoke-test that the config loads without startup errors.
- `emacs --batch -Q --eval "(progn (load-file \"init.el\") ...)"`: verify a specific command, keybinding, or module in batch mode.
- `M-x bootstrap-packages`: install missing packages on a new machine.
- `M-x missing-selected-packages`: inspect package drift without changing state.

When changing language modules, prefer targeted batch checks over manual guesswork.

## Coding Style & Naming Conventions

Use Emacs Lisp with `lexical-binding: t`. Indent with spaces using standard Emacs Lisp style; do not introduce tabs. Keep modules small and responsibility-focused. Use `init-` prefixes for shared modules and `lang-` prefixes for language modules. Prefer descriptive helper names; add a module- or domain-specific prefix only when it avoids ambiguity.

## Testing Guidelines

There is no separate test framework today. The minimum bar is:

- `emacs --batch -Q -l init.el`
- one targeted batch check for the feature you changed

Examples include verifying `eglot-server-programs`, checking `compile-command`, or asserting a keybinding with `lookup-key`.

## Commit & Pull Request Guidelines

Recent commits use short imperative subjects, for example `Enhance Rust cargo workflow` and `Improve CMake and Racket development tooling`. Follow that style: one concise line, capitalized, no trailing period.

For pull requests, include:

- a short summary of the user-facing behavior change
- any new external tool requirements such as `clangd`, `rustfmt`, or `racket`
- the batch commands used to verify the change

## Configuration Notes

Keep `custom-set-variables` and `custom-set-faces` in `init.el`. Do not commit transient runtime output. If adding packages, make sure both `package-selected-packages` and the relevant module configuration stay in sync.

## AI Assistant Interaction Rules

- **Explicit Commit Confirmation**: NEVER automatically run `git commit` or `git push` unless explicitly instructed or confirmed by the user. Always leave changes in the working directory or staging area and wait for the user's review and approval before committing.
