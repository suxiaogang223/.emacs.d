;;; init-tools.el --- Shared development tools -*- lexical-binding: t; -*-

;; Proxy helpers are global utilities, so keep them in a shared module.
(defvar proxy-server-address "127.0.0.1:7890"
  "Proxy server address used by `set-proxy'.")

(defun show-proxy ()
  "Show http/https proxy."
  (interactive)
  (if url-proxy-services
      (message "Current proxy is \"%s\"" proxy-server-address)
    (message "No proxy")))

(defun set-proxy ()
  "Set http/https proxy."
  (interactive)
  (setq url-proxy-services `(("http" . ,proxy-server-address)
                             ("https" . ,proxy-server-address)))
  (show-proxy))

(defun unset-proxy ()
  "Unset http/https proxy."
  (interactive)
  (setq url-proxy-services nil)
  (show-proxy))

(defun toggle-proxy ()
  "Toggle http/https proxy."
  (interactive)
  (if url-proxy-services
      (unset-proxy)
    (set-proxy)))

(require 'eldoc)
(setq eldoc-echo-area-use-multiline-p nil)

(defun enable-company-mode-if-available ()
  "Enable `company-mode' when it is available."
  (when (fboundp 'company-mode)
    (company-mode 1)))

(use-package flymake
  :ensure nil
  :bind (:map flymake-mode-map
              ("M-n" . flymake-goto-next-error)
              ("M-p" . flymake-goto-prev-error)))

(use-package project
  :ensure nil
  :bind-keymap ("C-c p" . project-prefix-map))

(use-package eglot
  :ensure nil
  :demand t
  :init
  (setq-default eglot-workspace-configuration
                '(:python (:analysis (:autoSearchPaths t
                                       :typeCheckingMode "basic"
                                       :useLibraryCodeForTypes t))))
  :config
  (define-key eglot-mode-map (kbd "C-c d") #'eldoc-doc-buffer)
  (define-key eglot-mode-map (kbd "C-c f") #'eglot-format))

(provide 'init-tools)

;;; init-tools.el ends here
