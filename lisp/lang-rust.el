;;; lang-rust.el --- Rust configuration -*- lexical-binding: t; -*-

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

(defun my-rust-setup ()
  "Set up development helpers for Rust buffers."
  (eglot-ensure)
  (company-mode 1))

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
  (define-key rust-mode-map (kbd "C-c C-c") #'rust-compile)
  (define-key rust-mode-map (kbd "C-c C-r") #'rust-run)
  (define-key rust-mode-map (kbd "C-c C-t") #'rust-test)
  (define-key rust-mode-map (kbd "C-c C-l") #'rust-run-clippy))

(with-eval-after-load 'rust-ts-mode
  (define-key rust-ts-mode-map (kbd "C-c C-f") #'rust-format-buffer)
  (define-key rust-ts-mode-map (kbd "C-c C-c") #'rust-compile)
  (define-key rust-ts-mode-map (kbd "C-c C-r") #'rust-run)
  (define-key rust-ts-mode-map (kbd "C-c C-t") #'rust-test)
  (define-key rust-ts-mode-map (kbd "C-c C-l") #'rust-run-clippy))

(provide 'lang-rust)

;;; lang-rust.el ends here
