;;; init-ui.el --- UI configuration -*- lexical-binding: t; -*-

(defun my-enable-auto-dark ()
  "Enable `auto-dark-mode' after the first GUI frame is ready."
  (when (display-graphic-p)
    (condition-case err
        (auto-dark-mode 1)
      (error
       (display-warning
        'init
        (format "auto-dark-mode disabled: %s" (error-message-string err))
        :warning)))))

(defvar auto-dark-themes)
(defvar auto-dark-allow-osascript)
(defvar auto-dark-detection-method)
(declare-function auto-dark-mode "auto-dark" (&optional arg))

(use-package auto-dark
  :ensure t
  :init
  (setq auto-dark-themes '((tango-dark) (tsdh-light)))
  (when (eq system-type 'darwin)
    ;; Prefer `osascript' and defer startup to avoid early AppleScript failures.
    (setq auto-dark-allow-osascript t
          auto-dark-detection-method 'osascript))
  :hook (window-setup . my-enable-auto-dark))

(provide 'init-ui)

;;; init-ui.el ends here
