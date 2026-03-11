;;; init-completion.el --- Minibuffer completion UI -*- lexical-binding: t; -*-

(use-package vertico
  :ensure nil
  :if (package-installed-p 'vertico)
  :init
  (vertico-mode))

(use-package marginalia
  :ensure nil
  :if (package-installed-p 'marginalia)
  :init
  (marginalia-mode))

(use-package orderless
  :ensure nil
  :if (package-installed-p 'orderless)
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles basic partial-completion)))))

(use-package consult
  :ensure nil
  :if (package-installed-p 'consult)
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         ("M-g g" . consult-goto-line)
         ("M-g i" . consult-imenu)))

(provide 'init-completion)

;;; init-completion.el ends here
