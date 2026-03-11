;;; init-editing.el --- Shared editing behavior -*- lexical-binding: t; -*-

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default standard-indent tab-width)

(require 'electric)

(defun add-electric-to-hook (hook)
  "Enable electric editing helpers for HOOK."
  (add-hook hook #'electric-pair-mode)
  (add-hook hook #'electric-indent-mode)
  (add-hook hook #'electric-quote-mode))

(provide 'init-editing)

;;; init-editing.el ends here
