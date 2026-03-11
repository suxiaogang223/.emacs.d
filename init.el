;;; init.el --- Personal Emacs configuration -*- lexical-binding: t; -*-

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-display-line-numbers-mode t)
 '(package-selected-packages
   '(auto-dark company consult magit marginalia orderless pyvenv racket-mode
               rust-mode use-package vertico))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Monaco" :foundry "nil" :slant normal :weight regular :height 130 :width normal)))))

(add-to-list
 'load-path
 (expand-file-name
  "lisp"
  (file-name-directory (or load-file-name user-init-file))))

(require 'init-package)
(require 'init-completion)
(require 'init-editing)
(require 'init-tools)
(require 'init-ui)
(require 'lang-elisp)
(require 'lang-python)
(require 'lang-cc)
(require 'lang-rust)
(require 'lang-racket)

;;; init.el ends here
