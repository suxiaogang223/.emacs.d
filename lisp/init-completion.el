;;; init-completion.el --- Minibuffer completion UI -*- lexical-binding: t; -*-

(when (package-installed-p 'vertico)
  (vertico-mode 1))

(when (package-installed-p 'marginalia)
  (marginalia-mode 1))

(when (package-installed-p 'orderless)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles basic partial-completion)))))

(when (package-installed-p 'consult)
  (global-set-key (kbd "C-s") #'consult-line)
  (global-set-key (kbd "C-x b") #'consult-buffer)
  (global-set-key (kbd "M-y") #'consult-yank-pop)
  (global-set-key (kbd "M-g g") #'consult-goto-line)
  (global-set-key (kbd "M-g i") #'consult-imenu))

(provide 'init-completion)

;;; init-completion.el ends here
