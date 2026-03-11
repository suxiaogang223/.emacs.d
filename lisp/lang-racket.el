;;; lang-racket.el --- Racket configuration -*- lexical-binding: t; -*-

(defun my-racket-setup ()
  "Set up development helpers for Racket buffers."
  (company-mode 1)
  (racket-xp-mode 1))

(add-hook 'racket-mode-hook #'my-racket-setup)
(add-electric-to-hook 'racket-mode-hook)

(with-eval-after-load 'racket-mode
  (define-key racket-mode-map (kbd "C-c C-z") #'racket-repl)
  (define-key racket-mode-map (kbd "C-c C-r") #'racket-run)
  (define-key racket-mode-map (kbd "C-c C-t") #'racket-test)
  (define-key racket-mode-map (kbd "M-n") #'racket-xp-next-error)
  (define-key racket-mode-map (kbd "M-p") #'racket-xp-previous-error))

(provide 'lang-racket)

;;; lang-racket.el ends here
