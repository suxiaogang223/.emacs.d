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
(defun enable-rust-ts-mode ()
  "Prefer `rust-ts-mode' when the tree-sitter Rust grammar is available."
  (when (and (fboundp 'treesit-available-p)
             (treesit-available-p)
             (fboundp 'treesit-language-available-p)
             (treesit-language-available-p 'rust))
    (add-to-list 'major-mode-remap-alist '(rust-mode . rust-ts-mode))))

(defun install-rust-treesit-grammar ()
  "Install the Rust tree-sitter grammar."
  (interactive)
  (unless (and (fboundp 'treesit-available-p) (treesit-available-p))
    (user-error "Tree-sitter is not available in this Emacs"))
  (add-to-list 'treesit-language-source-alist
               '(rust "https://github.com/tree-sitter/tree-sitter-rust"))
  (treesit-install-language-grammar 'rust)
  (enable-rust-ts-mode)
  (message "Installed Rust tree-sitter grammar"))

(defun rust-project-root ()
  "Return the current Rust project root."
  (or (locate-dominating-file default-directory "Cargo.toml")
      (when-let ((project (project-current nil)))
        (project-root project))))

(defun rust-target-command ()
  "Return a context-aware cargo command for the current buffer.
- In `tests/`: `cargo test --test <name>`
- In `examples/`: `cargo run --example <name>`
- In `benches/`: `cargo bench --bench <name>`
- Otherwise: `cargo check`"
  (let* ((root (rust-project-root))
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

(defun rust-set-compile-command ()
  "Set a project-aware `compile-command' for Rust."
  (when-let ((root (rust-project-root))
             (command (rust-target-command)))
    (setq-local compile-command
                (format "cd %s && %s"
                        (shell-quote-argument root)
                        command))))

(defun rust-run-cargo (args)
  "Run `cargo ARGS' from the current Rust project root."
  (let ((root (rust-project-root)))
    (unless root
      (user-error "No Cargo project found"))
    (compile
     (format "cd %s && cargo %s"
             (shell-quote-argument root)
             args))))

(defun format-rust-buffer ()
  "Format the current Rust buffer."
  (interactive)
  (cond
   ((fboundp 'rust-format-buffer)
    (rust-format-buffer))
   ((executable-find "rustfmt")
    (let ((point-pos (point)))
      (shell-command-on-region
       (point-min) (point-max)
       "rustfmt --emit stdout"
       (current-buffer) t "*rustfmt*")
      (goto-char (min point-pos (point-max)))))
   (t
    (user-error "Neither `rust-format-buffer' nor `rustfmt' is available"))))

(defun rust-check-project ()
  "Run `cargo check' for the current Rust project."
  (interactive)
  (rust-run-cargo "check"))

(defun rust-compile-project ()
  "Compile the current Rust target using `compile-command'."
  (interactive)
  (compile compile-command))

(defun rust-build-release ()
  "Run `cargo build --release' for the current Rust project."
  (interactive)
  (rust-run-cargo "build --release"))

(defun rust-run-project ()
  "Run `cargo run' for the current Rust project."
  (interactive)
  (rust-run-cargo "run"))

(defun rust-run-project-release ()
  "Run `cargo run --release' for the current Rust project."
  (interactive)
  (rust-run-cargo "run --release"))

(defun rust-test-project ()
  "Run `cargo test' for the current Rust project."
  (interactive)
  (rust-run-cargo "test"))

(defun rust-run-clippy ()
  "Run `cargo clippy' for the current Rust project."
  (interactive)
  (rust-run-cargo "clippy"))

(defun rust-build-doc ()
  "Build crate documentation for the current Rust project."
  (interactive)
  (rust-run-cargo "doc --no-deps"))

;; -- Mode Setup Hook --
(defun rust-setup ()
  "Set up development helpers for Rust buffers."
  (eglot-ensure)
  (enable-company-mode-if-available)
  (rust-set-compile-command)
  (add-hook 'before-save-hook #'format-rust-buffer nil t))

;; Enable Tree-sitter remapping if available.
(enable-rust-ts-mode)

;; -- Hooks --
(dolist (hook '(rust-mode-hook rust-ts-mode-hook))
  (add-hook hook #'rust-setup)
  (add-electric-to-hook hook))

;; -- Keybindings --
(defun rust-bind-keys (map)
  "Bind Rust-specific keys in MAP."
  (define-key map (kbd "C-c C-k") #'rust-check-project)
  (define-key map (kbd "C-c C-c") #'rust-compile-project)
  (define-key map (kbd "C-c C-b") #'rust-build-release)
  (define-key map (kbd "C-c C-r") #'rust-run-project)
  (define-key map (kbd "C-c C-e") #'rust-run-project-release)
  (define-key map (kbd "C-c C-t") #'rust-test-project)
  (define-key map (kbd "C-c C-l") #'rust-run-clippy)
  (define-key map (kbd "C-c C-d") #'rust-build-doc))

(with-eval-after-load 'rust-mode
  (rust-bind-keys rust-mode-map))

(with-eval-after-load 'rust-ts-mode
  (rust-bind-keys rust-ts-mode-map))

(provide 'lang-rust)

;;; lang-rust.el ends here
