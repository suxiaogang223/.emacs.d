;;; lang-cc.el --- C and C++ configuration -*- lexical-binding: t; -*-

(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
(add-hook 'c-mode-hook #'eglot-ensure)
(add-hook 'c++-mode-hook #'eglot-ensure)
(add-hook 'c-mode-hook #'company-mode)
(add-hook 'c++-mode-hook #'company-mode)
(add-electric-to-hook 'c-mode-hook)
(add-electric-to-hook 'c++-mode-hook)

(provide 'lang-cc)

;;; lang-cc.el ends here
