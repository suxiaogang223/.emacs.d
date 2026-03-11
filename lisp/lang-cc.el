;;; lang-cc.el --- C and C++ configuration -*- lexical-binding: t; -*-

(require 'compile)

(defun my-enable-c-ts-modes ()
  "Prefer tree-sitter C and C++ modes when grammars are available."
  (when (and (fboundp 'treesit-available-p)
             (treesit-available-p)
             (fboundp 'treesit-language-available-p))
    (when (treesit-language-available-p 'c)
      (add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode)))
    (when (treesit-language-available-p 'cpp)
      (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode)))))

(defun my-install-c/c++-treesit-grammars ()
  "Install tree-sitter grammars for C and C++."
  (interactive)
  (unless (and (fboundp 'treesit-available-p) (treesit-available-p))
    (user-error "Tree-sitter is not available in this Emacs"))
  (add-to-list 'treesit-language-source-alist
               '(c "https://github.com/tree-sitter/tree-sitter-c"))
  (add-to-list 'treesit-language-source-alist
               '(cpp "https://github.com/tree-sitter/tree-sitter-cpp"))
  (treesit-install-language-grammar 'c)
  (treesit-install-language-grammar 'cpp)
  (my-enable-c-ts-modes)
  (message "Installed tree-sitter grammars for C and C++"))

(defun my-clang-format-buffer ()
  "Format the current C or C++ buffer with clang-format."
  (interactive)
  (when (derived-mode-p 'c-mode 'c++-mode 'c-ts-mode 'c++-ts-mode)
    (unless (executable-find "clang-format")
      (user-error "Executable `clang-format' not found in PATH"))
    (let ((point-pos (point)))
      (shell-command-on-region
       (point-min) (point-max)
       "clang-format"
       (current-buffer) t "*clang-format*")
      (goto-char (min point-pos (point-max))))))

(defun my-c/c++-set-compile-command ()
  "Populate a sensible per-buffer compile command for C and C++."
  (setq-local compile-command
              (cond
               ((locate-dominating-file default-directory "Makefile")
                "make -k")
               ((locate-dominating-file default-directory "compile_commands.json")
                "cmake --build build")
               (buffer-file-name
                (format "%s %s -o %s"
                        (if (derived-mode-p 'c-mode 'c-ts-mode)
                            "clang -std=c17 -Wall -Wextra"
                          "clang++ -std=c++20 -Wall -Wextra")
                        (shell-quote-argument buffer-file-name)
                        (shell-quote-argument
                         (file-name-sans-extension
                          (file-name-nondirectory buffer-file-name)))))
               (t compile-command))))

(defun my-c/c++-setup ()
  "Set up development helpers for C and C++ buffers."
  (eglot-ensure)
  (company-mode 1)
  (my-c/c++-set-compile-command))

(add-to-list 'eglot-server-programs '((c++-mode c-mode c-ts-mode c++-ts-mode) "clangd"))
(my-enable-c-ts-modes)
(add-hook 'c-mode-hook #'my-c/c++-setup)
(add-hook 'c++-mode-hook #'my-c/c++-setup)
(when (fboundp 'c-ts-mode)
  (add-hook 'c-ts-mode-hook #'my-c/c++-setup))
(when (fboundp 'c++-ts-mode)
  (add-hook 'c++-ts-mode-hook #'my-c/c++-setup))
(add-electric-to-hook 'c-mode-hook)
(add-electric-to-hook 'c++-mode-hook)
(when (fboundp 'c-ts-mode)
  (add-electric-to-hook 'c-ts-mode-hook))
(when (fboundp 'c++-ts-mode)
  (add-electric-to-hook 'c++-ts-mode-hook))

(with-eval-after-load 'cc-mode
  (define-key c-mode-base-map (kbd "C-c C-c") #'compile)
  (define-key c-mode-base-map (kbd "C-c C-k") #'recompile)
  (define-key c-mode-base-map (kbd "C-c C-f") #'my-clang-format-buffer))

(provide 'lang-cc)

;;; lang-cc.el ends here
