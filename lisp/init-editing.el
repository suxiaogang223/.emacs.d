;;; init-editing.el --- Shared editing behavior -*- lexical-binding: t; -*-

;; -- Indentation & formatting --
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default standard-indent tab-width)

;; -- Line Numbers --
;; Prefer specific hooks over `global-display-line-numbers-mode` to keep
;; special buffers (like Dashboard, Terminals) perfectly clean.
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'text-mode-hook #'display-line-numbers-mode)
(add-hook 'conf-mode-hook #'display-line-numbers-mode)

;; -- Electric Editing --
(require 'electric)

(defun add-electric-to-hook (hook)
  "Enable electric editing helpers for HOOK."
  (add-hook hook #'electric-pair-mode)
  (add-hook hook #'electric-indent-mode)
  (add-hook hook #'electric-quote-mode))

(provide 'init-editing)

;;; init-editing.el ends here
