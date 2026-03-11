;;; lang-rust.el --- Rust configuration -*- lexical-binding: t; -*-

(require 'compile)
(require 'project)

(add-to-list 'eglot-server-programs '((rust-mode rust-ts-mode) "rust-analyzer"))

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
  "Return a context-aware cargo command for the current buffer."
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

(defun my-rust-setup ()
  "Set up development helpers for Rust buffers."
  (eglot-ensure)
  (company-mode 1)
  (my-rust-set-compile-command))

(my-enable-rust-ts-mode)
(add-hook 'before-save-hook #'my-rust-format-buffer-on-save)
(add-hook 'rust-mode-hook #'my-rust-setup)
(when (fboundp 'rust-ts-mode)
  (add-hook 'rust-ts-mode-hook #'my-rust-setup))
(add-electric-to-hook 'rust-mode-hook)
(when (fboundp 'rust-ts-mode)
  (add-electric-to-hook 'rust-ts-mode-hook))

(with-eval-after-load 'rust-mode
  (define-key rust-mode-map (kbd "C-c C-f") #'rust-format-buffer)
  (define-key rust-mode-map (kbd "C-c C-k") #'rust-check)
  (define-key rust-mode-map (kbd "C-c C-c") #'rust-compile)
  (define-key rust-mode-map (kbd "C-c C-b") #'rust-compile-release)
  (define-key rust-mode-map (kbd "C-c C-r") #'rust-run)
  (define-key rust-mode-map (kbd "C-c C-e") #'rust-run-release)
  (define-key rust-mode-map (kbd "C-c C-t") #'rust-test)
  (define-key rust-mode-map (kbd "C-c C-l") #'rust-run-clippy)
  (define-key rust-mode-map (kbd "C-c C-d") #'my-rust-doc))

(with-eval-after-load 'rust-ts-mode
  (define-key rust-ts-mode-map (kbd "C-c C-f") #'rust-format-buffer)
  (define-key rust-ts-mode-map (kbd "C-c C-k") #'rust-check)
  (define-key rust-ts-mode-map (kbd "C-c C-c") #'rust-compile)
  (define-key rust-ts-mode-map (kbd "C-c C-b") #'rust-compile-release)
  (define-key rust-ts-mode-map (kbd "C-c C-r") #'rust-run)
  (define-key rust-ts-mode-map (kbd "C-c C-e") #'rust-run-release)
  (define-key rust-ts-mode-map (kbd "C-c C-t") #'rust-test)
  (define-key rust-ts-mode-map (kbd "C-c C-l") #'rust-run-clippy)
  (define-key rust-ts-mode-map (kbd "C-c C-d") #'my-rust-doc))

(provide 'lang-rust)

;;; lang-rust.el ends here
