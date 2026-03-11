;;; lang-racket.el --- Racket configuration -*- lexical-binding: t; -*-

(add-hook 'racket-mode-hook #'eglot-ensure)
(add-electric-to-hook 'racket-mode-hook)

(provide 'lang-racket)

;;; lang-racket.el ends here
