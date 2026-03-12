;;; kanso-test-helper.el --- Shared helpers for Kanso tests -*- lexical-binding: t; -*-

;;; Commentary:
;; Shared helpers for Kanso's ERT suite.

;;; Code:

(require 'ert)

(defconst kanso-test-root
  (expand-file-name ".." (file-name-directory (or load-file-name buffer-file-name)))
  "Repository root used by the Kanso test suite.")

(defun kanso-test-repo-file (path)
  "Return PATH relative to the repository root."
  (expand-file-name path kanso-test-root))

(defun kanso-test-auto-mode (filename)
  "Return the major mode selected for FILENAME."
  (assoc-default filename auto-mode-alist #'string-match))

(defun kanso-test-write-file (root relative-path contents)
  "Write CONTENTS to RELATIVE-PATH under ROOT."
  (let ((path (expand-file-name relative-path root)))
    (make-directory (file-name-directory path) t)
    (with-temp-file path
      (insert contents))))

(defmacro kanso-test-with-project (files &rest body)
  "Create a temporary project with FILES and run BODY inside it."
  (declare (indent 1) (debug t))
  `(let ((root (make-temp-file "kanso-test-" t)))
     (unwind-protect
         (progn
           (dolist (file ,files)
             (kanso-test-write-file root (car file) (cdr file)))
           (let ((default-directory root))
             ,@body))
       (delete-directory root t))))

(provide 'kanso-test-helper)

;;; kanso-test-helper.el ends here
