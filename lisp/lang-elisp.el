;;; lang-elisp.el --- Emacs Lisp configuration -*- lexical-binding: t; -*-

(add-hook 'emacs-lisp-mode-hook #'company-mode)
(add-electric-to-hook 'emacs-lisp-mode-hook)

(provide 'lang-elisp)

;;; lang-elisp.el ends here
