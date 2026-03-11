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
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  
  ;; Basic Configuration
  (setq dashboard-startup-banner (expand-file-name "img/kanso-icon.svg" user-emacs-directory))
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t)
  
  ;; Banner text
  (setq dashboard-banner-logo-title "K A N S O    E M A C S")
  
  ;; Customize widgets
  (setq dashboard-items '((recents  . 5)
                          (projects . 5)))
  
  ;; Appearance
  ;; Keep Kanso minimal: disable heavy third-party icons (all-the-icons/nerd-icons)
  (setq dashboard-set-heading-icons nil)
  (setq dashboard-set-file-icons nil)
  (setq dashboard-set-init-info t)
  
  ;; Footer (Documentation Link)
  (setq dashboard-set-footer nil)
  (setq dashboard-footer-messages '("Press ? for help | Docs: suxiaogang223.github.io/kanso-emacs"))
  (setq dashboard-footer-icon "")
  
  ;; Hooks for aesthetics
  ;; We use `dashboard-after-initialize-hook` instead of `dashboard-mode-hook`
  ;; because global modes (like `global-display-line-numbers-mode`) load late
  ;; and can override mode hooks.
  (add-hook 'dashboard-after-initialize-hook
            (lambda ()
              (display-line-numbers-mode -1))))

(provide 'init-ui)

;;; init-ui.el ends here
