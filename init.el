;;; init.el --- Personal Emacs configuration -*- lexical-binding: t; -*-

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-display-line-numbers-mode t)
 '(package-selected-packages '(auto-dark company magit racket-mode rust-mode))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Monaco" :foundry "nil" :slant normal :weight regular :height 130 :width normal)))))

(require 'package)
(setopt package-archives
        '(("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
          ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
          ("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(unless package--initialized
  (package-initialize))

;; set indent and tab-width
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default standard-indent tab-width)

;; Configure network proxy
(defvar my-proxy "127.0.0.1:7890"
  "Proxy server address used by `set-proxy'.")

(defun show-proxy ()
  "Show http/https proxy."
  (interactive)
  (if url-proxy-services
      (message "Current proxy is \"%s\"" my-proxy)
    (message "No proxy")))

(defun set-proxy ()
  "Set http/https proxy."
  (interactive)
  (setq url-proxy-services `(("http" . ,my-proxy)
                             ("https" . ,my-proxy)))
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

;; enable lsp
(require 'eglot)
(require 'eldoc)
;; set key for eglot-mode
(define-key eglot-mode-map (kbd "C-c d") #'eldoc-doc-buffer)
(define-key eglot-mode-map (kbd "C-c f") #'eglot-format)

(require 'electric)
(defun add-electric-to-hook (hook)
  "Enable electric editing helpers for HOOK."
  (add-hook hook #'electric-pair-mode)
  (add-hook hook #'electric-indent-mode)
  (add-hook hook #'electric-quote-mode))

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

;; set auto-dark
(use-package auto-dark
  :ensure t
  :init
  (setq auto-dark-themes '((tango-dark) (tsdh-light)))
  (when (eq system-type 'darwin)
    ;; Prefer `osascript' and defer startup to avoid early AppleScript failures.
    (setq auto-dark-allow-osascript t
          auto-dark-detection-method 'osascript))
  :hook (window-setup . my-enable-auto-dark))

(require 'company)

;; emacs-lisp
(add-hook 'emacs-lisp-mode-hook #'company-mode)
(add-electric-to-hook 'emacs-lisp-mode-hook)

;; racket
(add-hook 'racket-mode-hook #'eglot-ensure)
;; (add-hook 'racket-mode-hook 'company-mode)
(add-electric-to-hook 'racket-mode-hook)

;; c/c++
(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
(add-hook 'c-mode-hook #'eglot-ensure)
(add-hook 'c++-mode-hook #'eglot-ensure)
(add-hook 'c-mode-hook #'company-mode)
(add-hook 'c++-mode-hook #'company-mode)
(add-electric-to-hook 'c-mode-hook)
(add-electric-to-hook 'c++-mode-hook)

;; rust
(add-hook 'rust-mode-hook #'eglot-ensure)
(add-hook 'rust-mode-hook #'company-mode)
(add-electric-to-hook 'rust-mode-hook)
