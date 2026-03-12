;;; init-ui.el --- UI configuration -*- lexical-binding: t; -*-

(defun enable-auto-dark ()
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
  :init
  (setq auto-dark-themes '((tango-dark) (tsdh-light)))
  (when (eq system-type 'darwin)
    ;; Prefer `osascript' and defer startup to avoid early AppleScript failures.
    (setq auto-dark-allow-osascript t
          auto-dark-detection-method 'osascript))
  :hook (window-setup . enable-auto-dark))

;; -- Dashboard (Startup Screen) --
(defconst kanso-dashboard-footer-messages
  '("如无必要，勿增实体"
    "本来无一物，何处惹尘埃"
    "Noting, everything"
    "Keep it simple, stupid")
  "Footer messages displayed on the dashboard.")

(use-package dashboard
  :init
  (setq initial-buffer-choice 'dashboard-open)
  :config
  ;; Basic Configuration
  (setq dashboard-startup-banner (expand-file-name "img/kanso-icon.svg" user-emacs-directory))
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t)
  
  ;; Banner text
  (setq dashboard-banner-logo-title "K A N S O    E M A C S")
  
  ;; Navigator buttons
  (setq dashboard-set-navigator t)
  (setq dashboard-navigator-buttons
        `(;; line1
          ((,""
            "📖 Docs"
            "Open Documentation"
            (lambda (&rest _) (browse-url "https://suxiaogang223.github.io/kanso-emacs/")))
           (,""
            "⭐ Repo"
            "View Source Code"
            (lambda (&rest _) (browse-url "https://github.com/suxiaogang223/kanso-emacs")))
           (,""
            "👤 Author"
            "Visit @suxiaogang223"
            (lambda (&rest _) (browse-url "https://github.com/suxiaogang223"))))))
  
  ;; Customize widgets
  (setq dashboard-items '((recents   . 5)
                          (projects  . 5)))
  
  ;; Explicitly tell Dashboard to render the navigator buttons
  (setq dashboard-startupify-list '(dashboard-insert-banner
                                    dashboard-insert-newline
                                    dashboard-insert-banner-title
                                    dashboard-insert-newline
                                    dashboard-insert-navigator
                                    dashboard-insert-newline
                                    dashboard-insert-init-info
                                    dashboard-insert-items
                                    dashboard-insert-newline
                                    dashboard-insert-footer))
  
  ;; Appearance
  (setq dashboard-footer-messages kanso-dashboard-footer-messages)
  (setq dashboard-footer-icon "")

  ;; Initialize Dashboard after setting variables.
  (dashboard-setup-startup-hook))

(provide 'init-ui)

;;; init-ui.el ends here
