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
(require 'rust-cargo nil t)
(require 'rust-rustfmt nil t)

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
    (my-rust-format-buffer)))

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

(defun my-rust-run-cargo (args)
  "Run `cargo ARGS' from the current Rust project root."
  (let ((root (my-rust-project-root)))
    (unless root
      (user-error "No Cargo project found"))
    (compile
     (format "cd %s && cargo %s"
             (shell-quote-argument root)
             args))))

(defun my-rust-format-buffer ()
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

(defun my-rust-check ()
  "Run `cargo check' for the current Rust project."
  (interactive)
  (my-rust-run-cargo "check"))

(defun my-rust-compile ()
  "Compile the current Rust target using `compile-command'."
  (interactive)
  (compile compile-command))

(defun my-rust-compile-release ()
  "Run `cargo build --release' for the current Rust project."
  (interactive)
  (my-rust-run-cargo "build --release"))

(defun my-rust-run ()
  "Run `cargo run' for the current Rust project."
  (interactive)
  (my-rust-run-cargo "run"))

(defun my-rust-run-release ()
  "Run `cargo run --release' for the current Rust project."
  (interactive)
  (my-rust-run-cargo "run --release"))

(defun my-rust-test ()
  "Run `cargo test' for the current Rust project."
  (interactive)
  (my-rust-run-cargo "test"))

(defun my-rust-run-clippy ()
  "Run `cargo clippy' for the current Rust project."
  (interactive)
  (my-rust-run-cargo "clippy"))

(defun my-rust-doc ()
  "Build crate documentation for the current Rust project."
  (interactive)
  (my-rust-run-cargo "doc --no-deps"))

;; -- Mode Setup Hook --
(defun my-rust-setup ()
  "Set up development helpers for Rust buffers."
  (eglot-ensure)
  (my-enable-company-mode)
  (my-rust-set-compile-command)
  (add-hook 'before-save-hook #'my-rust-format-buffer-on-save nil t))

;; Enable Tree-sitter remapping if available.
(my-enable-rust-ts-mode)

;; -- Hooks --
(add-hook 'rust-mode-hook #'my-rust-setup)
(when (fboundp 'rust-ts-mode)
  (add-hook 'rust-ts-mode-hook #'my-rust-setup))
(add-electric-to-hook 'rust-mode-hook)
(when (fboundp 'rust-ts-mode)
  (add-electric-to-hook 'rust-ts-mode-hook))

;; -- Keybindings --
(defun my-rust-bind-keys (map)
  "Bind Rust-specific keys in MAP."
  (define-key map (kbd "C-c C-f") #'my-rust-format-buffer)
  (define-key map (kbd "C-c C-k") #'my-rust-check)
  (define-key map (kbd "C-c C-c") #'my-rust-compile)
  (define-key map (kbd "C-c C-b") #'my-rust-compile-release)
  (define-key map (kbd "C-c C-r") #'my-rust-run)
  (define-key map (kbd "C-c C-e") #'my-rust-run-release)
  (define-key map (kbd "C-c C-t") #'my-rust-test)
  (define-key map (kbd "C-c C-l") #'my-rust-run-clippy)
  (define-key map (kbd "C-c C-d") #'my-rust-doc))

(with-eval-after-load 'rust-mode
  (my-rust-bind-keys rust-mode-map))

(with-eval-after-load 'rust-ts-mode
  (my-rust-bind-keys rust-ts-mode-map))

(provide 'lang-rust)

;;; lang-rust.el ends here
