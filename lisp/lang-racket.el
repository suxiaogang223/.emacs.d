;;; lang-racket.el --- Racket configuration -*- lexical-binding: t; -*-

(add-hook 'racket-mode-hook #'enable-company-mode-if-available)
(add-hook 'racket-mode-hook #'racket-xp-mode)
(add-electric-to-hook 'racket-mode-hook)

(with-eval-after-load 'racket-mode
  (define-key racket-mode-map (kbd "C-c C-z") #'racket-repl)
  (define-key racket-mode-map (kbd "C-c C-r") #'racket-run)
  (define-key racket-mode-map (kbd "C-c C-d") #'racket-xp-documentation)
  (define-key racket-mode-map (kbd "C-c C-s") #'racket-documentation-search)
  (define-key racket-mode-map (kbd "C-c C-p") #'racket-profile)
  (define-key racket-mode-map (kbd "M-n") #'racket-xp-next-error)
  (define-key racket-mode-map (kbd "M-p") #'racket-xp-previous-error))

(with-eval-after-load 'racket-repl
  (define-key racket-repl-mode-map (kbd "C-c C-z") #'racket-repl-switch-to-edit)
  (define-key racket-repl-mode-map (kbd "C-c C-k") #'racket-repl-clear))

(provide 'lang-racket)

;;; lang-racket.el ends here
