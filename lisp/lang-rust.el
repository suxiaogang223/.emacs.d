;;; lang-rust.el --- Rust configuration and tooling -*- lexical-binding: t; -*-

;;; Commentary:
;; This module provides a robust development environment for Rust.
;; 1. Configures `eglot` with `rust-analyzer` for IDE-like features.
;; 2. Supports both `rust-mode` and `rust-ts-mode` (Tree-sitter).
;; 3. Provides intelligent, project-aware `compile-command` for `cargo`.
;; 4. Adds shortcuts for common Cargo tasks (test, check, doc, etc.).

;;; Code:

(require 'compile)
(require 'project)

;; -- Language Server Protocol (LSP) --
;; Register `rust-analyzer` for both standard and Tree-sitter modes.
(add-to-list 'eglot-server-programs '((rust-mode rust-ts-mode) "rust-analyzer"))

;; -- Tree-sitter Support --
(defun my-enable-rust-ts-mode ()
  "Prefer `rust-ts-mode' when the tree-sitter Rust grammar is available."
  (when (and (fboundp 'treesit-available-p)
             (treesit-available-p)
             (fboundp 'treesit-language-available-p)
             (treesit-language-available-p 'rust))
    (add-to-list 'major-mode-remap-alist '(rust-mode . rust-ts-mode))))

(defun my-install-rust-treesit-grammar ()
  "Install the Rust tree-sitter grammar."
  (interactive)
  (unless (and (fboundp 'treesit-available-p) (treesit-available-p))
    (user-error "Tree-sitter is not available in this Emacs"))
  (add-to-list 'treesit-language-source-alist
               '(rust "https://github.com/tree-sitter/tree-sitter-rust"))
  (treesit-install-language-grammar 'rust)
  (my-enable-rust-ts-mode)
  (message "Installed Rust tree-sitter grammar"))

;; -- Helper Functions --
(defun my-rust-format-buffer-on-save ()
  "Format the current Rust buffer before saving."
  (when (derived-mode-p 'rust-mode 'rust-ts-mode)
    (rust-format-buffer)))

(defun my-rust-project-root ()
  "Return the current Rust project root."
  (or (locate-dominating-file default-directory "Cargo.toml")
      (when-let ((project (project-current nil)))
        (project-root project))))

(defun my-rust-target-command ()
  "Return a context-aware cargo command for the current buffer.
- In `tests/`: `cargo test --test <name>`
- In `examples/`: `cargo run --example <name>`
- In `benches/`: `cargo bench --bench <name>`
- Otherwise: `cargo check`"
  (let* ((root (my-rust-project-root))
         (relative (and root buffer-file-name
                        (file-relative-name buffer-file-name root)))
         (target (and relative (file-name-base relative))))
    (cond
     ((null root) nil)
     ((and relative (string-prefix-p "tests/" relative))
      (format "cargo test --test %s" (shell-quote-argument target)))
     ((and relative (string-prefix-p "examples/" relative))
      (format "cargo run --example %s" (shell-quote-argument target)))
     ((and relative (string-prefix-p "benches/" relative))
      (format "cargo bench --bench %s" (shell-quote-argument target)))
     (t "cargo check"))))

(defun my-rust-set-compile-command ()
  "Set a project-aware `compile-command' for Rust."
  (when-let ((root (my-rust-project-root))
             (command (my-rust-target-command)))
    (setq-local compile-command
                (format "cd %s && %s"
                        (shell-quote-argument root)
                        command))))

(defun my-rust-doc ()
  "Build crate documentation for the current Rust project."
  (interactive)
  (let ((root (my-rust-project-root)))
    (unless root
      (user-error "No Cargo project found"))
    (compile
     (format "cd %s && cargo doc --no-deps"
             (shell-quote-argument root)))))

;; -- Mode Setup Hook --
(defun my-rust-setup ()
  "Set up development helpers for Rust buffers."
  (eglot-ensure)
  (company-mode 1)
  (my-rust-set-compile-command))

;; Enable Tree-sitter remapping if available.
(my-enable-rust-ts-mode)

;; -- Hooks --
(add-hook 'before-save-hook #'my-rust-format-buffer-on-save)
(add-hook 'rust-mode-hook #'my-rust-setup)
(when (fboundp 'rust-ts-mode)
  (add-hook 'rust-ts-mode-hook #'my-rust-setup))
(add-electric-to-hook 'rust-mode-hook)
(when (fboundp 'rust-ts-mode)
  (add-electric-to-hook 'rust-ts-mode-hook))

;; -- Keybindings --
(defun my-rust-bind-keys (map)
  "Bind Rust-specific keys in MAP."
  (define-key map (kbd "C-c C-f") #'rust-format-buffer)
  (define-key map (kbd "C-c C-k") #'rust-check)
  (define-key map (kbd "C-c C-c") #'rust-compile)
  (define-key map (kbd "C-c C-b") #'rust-compile-release)
  (define-key map (kbd "C-c C-r") #'rust-run)
  (define-key map (kbd "C-c C-e") #'rust-run-release)
  (define-key map (kbd "C-c C-t") #'rust-test)
  (define-key map (kbd "C-c C-l") #'rust-run-clippy)
  (define-key map (kbd "C-c C-d") #'my-rust-doc))

(with-eval-after-load 'rust-mode
  (my-rust-bind-keys rust-mode-map))

(with-eval-after-load 'rust-ts-mode
  (my-rust-bind-keys rust-ts-mode-map))

(provide 'lang-rust)

;;; lang-rust.el ends here
