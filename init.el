;;; init.el --- Personal Emacs configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; This is the main entry point for the Emacs configuration.
;; It handles:
;; 1. User-defined variables and faces via Custom.
;; 2. Modular configuration loading from the `lisp/` directory.
;; 3. Core package initialization and language module registration.

;;; Code:

;; -- Custom Variables & Faces --
;; These are managed by Emacs Customization system.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
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

;; -- Module Loading System --
;; Add the `lisp` directory to `load-path` so we can require our modules.
(add-to-list
 'load-path
 (expand-file-name
  "lisp"
  (file-name-directory (or load-file-name user-init-file))))

;; -- Feature Modules --
(require 'init-package)    ; Package manager setup (must be first)
(require 'init-completion) ; Minibuffer completion UI
(require 'init-editing)    ; Shared editing behavior
(require 'init-tools)      ; Development tools (Eglot, Company, etc.)
(require 'init-ui)         ; Visual styling and theme

;; -- Language Modules --
(require 'lang-elisp)      ; Emacs Lisp development
(require 'lang-python)     ; Python development
(require 'lang-cc)         ; C/C++ development
(require 'lang-rust)       ; Rust development
(require 'lang-racket)     ; Racket development

;;; init.el ends here
