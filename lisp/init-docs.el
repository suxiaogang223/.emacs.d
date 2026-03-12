;;; init-docs.el --- Org and Markdown authoring support -*- lexical-binding: t; -*-

;;; Commentary:
;; This module improves the everyday writing experience for Org and Markdown.
;; 1. Applies consistent text-buffer UI defaults for prose editing.
;; 2. Enhances Org with better visual presentation and source block behavior.
;; 3. Adds Markdown/GFM support with practical navigation and TOC helpers.

;;; Code:

(defun docs-text-ui ()
  "Apply shared UI defaults for prose-oriented document buffers."
  (visual-line-mode 1)
  (display-line-numbers-mode -1))

(with-eval-after-load 'markdown-mode
  ;; `markdown-code-face' defaults to `fixed-pitch`; keep docs on the main font.
  (set-face-attribute 'markdown-code-face nil :inherit 'default))

(use-package org
  :ensure nil
  :hook ((org-mode . docs-text-ui)
         (org-mode . org-indent-mode))
  :init
  (setq org-edit-src-content-indentation 0)
  :config
  (require 'org-tempo))

(use-package org-modern
  :after org
  :hook (org-mode . org-modern-mode))

(use-package toc-org
  :hook ((org-mode . toc-org-mode)
         (markdown-mode . toc-org-mode)
         (gfm-mode . toc-org-mode)))

(use-package markdown-mode
  :hook ((markdown-mode . docs-text-ui)
         (gfm-mode . docs-text-ui))
  :bind ((:map markdown-mode-map
               ("C-c C-p" . markdown-preview)
               ("C-c C-t" . toc-org-mode))
         (:map gfm-mode-map
               ("C-c C-p" . markdown-preview)
               ("C-c C-t" . toc-org-mode)))
  :init
  (add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
  (setq markdown-fontify-code-blocks-natively t))

(provide 'init-docs)

;;; init-docs.el ends here
