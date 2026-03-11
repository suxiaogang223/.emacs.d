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

;; -- Dashboard (Startup Screen) --
(defun my-kanso-open-docs ()
  "Open the Kanso Emacs documentation."
  (interactive)
  (browse-url "https://suxiaogang223.github.io/kanso-emacs/"))

(defun my-kanso-open-repo ()
  "Open the Kanso Emacs GitHub repository."
  (interactive)
  (browse-url "https://github.com/suxiaogang223/kanso-emacs"))

(defun my-kanso-open-author ()
  "Open the author's GitHub profile."
  (interactive)
  (browse-url "https://github.com/suxiaogang223"))

(use-package dashboard
  :ensure t
  :bind (:map dashboard-mode-map
              ("?" . my-kanso-open-docs))
  :init
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
            (lambda (&rest _) (my-kanso-open-docs)))
           (,""
            "⭐ Repo"
            "View Source Code"
            (lambda (&rest _) (my-kanso-open-repo)))
           (,""
            "👤 Author"
            "Visit @suxiaogang223"
            (lambda (&rest _) (my-kanso-open-author))))))
  
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
  ;; Keep Kanso minimal: disable heavy third-party icons
  (setq dashboard-set-heading-icons nil)
  (setq dashboard-set-file-icons nil)
  (setq dashboard-set-init-info t)
  
  ;; Footer
  (setq dashboard-set-footer nil)
  (setq dashboard-footer-messages '("Press ? to open documentation"))
  (setq dashboard-footer-icon "")
  
  :config
  (dashboard-setup-startup-hook)
  
  ;; Hooks for aesthetics
  (add-hook 'dashboard-after-initialize-hook
            (lambda ()
              (display-line-numbers-mode -1))))

(provide 'init-ui)

;;; init-ui.el ends here
