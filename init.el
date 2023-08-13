(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(tsdh-light))
 '(global-display-line-numbers-mode t)
 '(package-selected-packages '(rust-mode company))
 '(scroll-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Monaco" :foundry "nil" :slant normal :weight regular :height 130 :width normal)))))

(require 'package)
(setq package-archives '(("gnu"    . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa"  . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(package-initialize)

;; set indent and tab-width
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(defvaralias 'c-basic-offset 'tab-width)

(require 'eldoc)
(global-eldoc-mode)
(global-set-key (kbd "C-c d") 'eldoc)

;; enable lsp
(require 'eglot)
;; set key for eglot-mode
(define-key eglot-mode-map (kbd "C-c f") 'eglot-format)

(require 'electric)
(defun add-electric-to-hook (hook)
  (add-hook hook 'electric-pair-mode)
  (add-hook hook 'electric-indent-mode)
  (add-hook hook 'electric-quote-mode))

(require 'company)

;; emacs-lisp
(add-hook 'emacs-lisp-mode-hook 'company-mode)
(add-electric-to-hook 'emacs-lisp-mode-hook)

;; c/c++
(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)
(add-hook 'c-mode-hook 'company-mode)
(add-hook 'c++-mode-hook 'company-mode)
(add-electric-to-hook 'c-mode-hook)
(add-electric-to-hook 'c++-mode-hook)

;; rust
(add-hook 'rust-mode-hook 'eglot-ensure)
(add-hook 'rust-mode-hook 'company-mode)
(add-electric-to-hook 'rust-mode-hook)
