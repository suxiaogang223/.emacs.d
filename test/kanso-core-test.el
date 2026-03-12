;;; kanso-core-test.el --- Core Kanso configuration tests -*- lexical-binding: t; -*-

;;; Commentary:
;; Stable ERT coverage for shared configuration behavior.

;;; Code:

(require 'eglot)
(require 'flymake)
(require 'kanso-test-helper)
(require 'markdown-mode)
(require 'project)

(ert-deftest kanso-core-completion-bindings ()
  "Completion bindings should point to Consult commands."
  (should (eq (lookup-key global-map (kbd "C-s")) #'consult-line))
  (should (eq (lookup-key global-map (kbd "C-x b")) #'consult-buffer))
  (should (eq (lookup-key global-map (kbd "M-y")) #'consult-yank-pop)))

(ert-deftest kanso-core-docs-hooks-and-settings ()
  "Document buffers should pick up the expected hooks and faces."
  (should (memq #'docs-text-ui org-mode-hook))
  (should (memq #'org-indent-mode org-mode-hook))
  (should (memq #'docs-text-ui markdown-mode-hook))
  (should (eq org-edit-src-content-indentation 0))
  (should (eq (face-attribute 'markdown-code-face :inherit nil t) 'default)))

(ert-deftest kanso-core-readme-uses-gfm-mode ()
  "README files should open in GFM mode."
  (should (eq (kanso-test-auto-mode "README.md") 'gfm-mode)))

(ert-deftest kanso-core-tools-bindings-and-settings ()
  "Shared tools should retain their configured keybindings and settings."
  (should (functionp (lookup-key global-map (kbd "C-c p"))))
  (should (eq (lookup-key flymake-mode-map (kbd "M-n")) #'flymake-goto-next-error))
  (should (eq (lookup-key flymake-mode-map (kbd "M-p")) #'flymake-goto-prev-error))
  (should (equal eglot-workspace-configuration
                 '(:python (:analysis (:autoSearchPaths t
                                        :typeCheckingMode "basic"
                                        :useLibraryCodeForTypes t))))))

(ert-deftest kanso-core-package-archive-profiles ()
  "Package archive profile selection should support CI overrides."
  (should (equal (kanso-package-archives-for-profile "tsinghua")
                 kanso-package-archives-tsinghua))
  (should (equal (kanso-package-archives-for-profile "official")
                 kanso-package-archives-official)))

(provide 'kanso-core-test)

;;; kanso-core-test.el ends here
