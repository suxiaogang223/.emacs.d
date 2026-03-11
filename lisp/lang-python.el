;;; lang-python.el --- Python configuration -*- lexical-binding: t; -*-

(defun my-enable-python-ts-mode ()
  "Prefer `python-ts-mode' when tree-sitter Python grammar is available."
  (when (and (fboundp 'treesit-available-p)
             (treesit-available-p)
             (fboundp 'treesit-language-available-p)
             (treesit-language-available-p 'python))
    (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))))

;; Install the Python tree-sitter grammar with:
;; M-x my-install-python-treesit-grammar
(defun my-install-python-treesit-grammar ()
  "Install the Python tree-sitter grammar and enable `python-ts-mode'."
  (interactive)
  (unless (and (fboundp 'treesit-available-p) (treesit-available-p))
    (user-error "Tree-sitter is not available in this Emacs"))
  (add-to-list 'treesit-language-source-alist
               '(python "https://github.com/tree-sitter/tree-sitter-python"))
  (treesit-install-language-grammar 'python)
  (my-enable-python-ts-mode)
  (message "Installed Python tree-sitter grammar; Python files will use python-ts-mode"))

(defun my-python-format-buffer ()
  "Format the current Python buffer with Ruff."
  (when (derived-mode-p 'python-mode 'python-ts-mode)
    (unless (executable-find "ruff")
      (user-error "Executable `ruff' not found in PATH"))
    (let ((point-pos (point))
          (filename (shell-quote-argument (or buffer-file-name "stdin.py"))))
      (shell-command-on-region
       (point-min) (point-max)
       (format "ruff format --stdin-filename %s -" filename)
       (current-buffer) t "*ruff-format*")
      (goto-char (min point-pos (point-max))))))

(defun my-python-format-buffer-on-save ()
  "Format Python buffers with Ruff before saving."
  (when (derived-mode-p 'python-mode 'python-ts-mode)
    (my-python-format-buffer)))

(use-package pyvenv
  :ensure nil
  :if (locate-library "pyvenv")
  :config
  (pyvenv-mode 1))

(add-to-list 'eglot-server-programs
             '((python-mode python-ts-mode)
               "pyright-langserver" "--stdio"))

(my-enable-python-ts-mode)
(add-hook 'before-save-hook #'my-python-format-buffer-on-save)
(add-hook 'python-mode-hook #'eglot-ensure)
(add-hook 'python-ts-mode-hook #'eglot-ensure)
(add-hook 'python-mode-hook #'company-mode)
(add-hook 'python-ts-mode-hook #'company-mode)
(add-electric-to-hook 'python-mode-hook)
(add-electric-to-hook 'python-ts-mode-hook)

(with-eval-after-load 'python
  (define-key python-mode-map (kbd "C-c C-z") #'run-python)
  (when (boundp 'python-ts-mode-map)
    (define-key python-ts-mode-map (kbd "C-c C-z") #'run-python)))

(provide 'lang-python)

;;; lang-python.el ends here
