;;; init-docs.el --- Org and Markdown authoring support -*- lexical-binding: t; -*-

;;; Commentary:
;; This module improves the everyday writing experience for Org and Markdown.
;; 1. Applies consistent text-buffer UI defaults for prose editing.
;; 2. Enhances Org with better visual presentation and source block behavior.
;; 3. Adds Markdown/GFM support with practical navigation and TOC helpers.

;;; Code:

(require 'use-package)

(defun docs-text-ui ()
  "Apply shared UI defaults for prose-oriented document buffers."
  (visual-line-mode 1)
  (display-line-numbers-mode -1)
  (variable-pitch-mode 1))

(defun docs-set-fixed-pitch-faces ()
  "Keep code-like faces aligned when `variable-pitch-mode' is enabled."
  (with-eval-after-load 'org
    (set-face-attribute 'org-block nil :inherit '(fixed-pitch))
    (set-face-attribute 'org-block-begin-line nil :inherit '(fixed-pitch shadow))
    (set-face-attribute 'org-block-end-line nil :inherit '(fixed-pitch shadow))
    (set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-document-info-keyword nil :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-meta-line nil :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-property-value nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-table nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-tag nil :inherit '(shadow fixed-pitch) :weight 'normal)
    (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch)))
  (with-eval-after-load 'markdown-mode
    (set-face-attribute 'markdown-code-face nil :inherit 'fixed-pitch)
    (set-face-attribute 'markdown-inline-code-face nil :inherit '(shadow fixed-pitch))
    (set-face-attribute 'markdown-language-keyword-face nil :inherit '(shadow fixed-pitch))
    (set-face-attribute 'markdown-markup-face nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'markdown-metadata-key-face nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'markdown-pre-face nil :inherit 'fixed-pitch)))

(defun org-docs-setup ()
  "Set up an Org buffer for document authoring."
  (docs-text-ui)
  (org-indent-mode 1))

(defun markdown-docs-setup ()
  "Set up a Markdown buffer for document authoring."
  (docs-text-ui))

(defun enable-org-modern-mode ()
  "Enable `org-modern-mode' when the package is available."
  (when (fboundp 'org-modern-mode)
    (org-modern-mode 1)))

(defun enable-toc-org-mode ()
  "Enable `toc-org-mode' when the package is available."
  (when (fboundp 'toc-org-mode)
    (toc-org-mode 1)))

(docs-set-fixed-pitch-faces)

(use-package org
  :ensure nil
  :hook (org-mode . org-docs-setup)
  :bind ((:map org-mode-map
               ("C-c C-o" . org-open-at-point)
               ("C-c C-t" . org-todo)
               ("C-c C-e" . org-export-dispatch)))
  :init
  (setq org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 0)
  :config
  (require 'org-tempo))

(use-package org-modern
  :after org
  :hook (org-mode . enable-org-modern-mode))

(use-package toc-org
  :hook ((org-mode . enable-toc-org-mode)
         (markdown-mode . enable-toc-org-mode)
         (gfm-mode . enable-toc-org-mode)))

(use-package markdown-mode
  :mode ("\\.md\\'" . markdown-mode)
  :hook ((markdown-mode . markdown-docs-setup)
         (gfm-mode . markdown-docs-setup))
  :bind ((:map markdown-mode-map
               ("C-c C-o" . markdown-follow-thing-at-point)
               ("C-c C-p" . markdown-preview)
               ("C-c C-t" . toc-org-mode))
         (:map gfm-mode-map
               ("C-c C-o" . markdown-follow-thing-at-point)
               ("C-c C-p" . markdown-preview)
               ("C-c C-t" . toc-org-mode)))
  :init
  ;; Insert the generic rule first so the README-specific rule can override it.
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
  (setq markdown-fontify-code-blocks-natively t))

(provide 'init-docs)

;;; init-docs.el ends here
