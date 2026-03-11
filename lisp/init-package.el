;;; init-package.el --- Package bootstrap and management -*- lexical-binding: t; -*-

;;; Commentary:
;; This module handles package management and bootstrapping.
;; 1. Configures reliable package mirrors (TSinghua mirrors by default).
;; 2. Automates the installation of missing packages listed in `package-selected-packages`.
;; 3. Provides `my-bootstrap-packages` for new machine setups.

;;; Code:

(require 'seq)
(require 'package)

;; -- Package Mirror Configuration --
;; Use TSinghua mirrors for faster and more reliable package downloads in mainland China.
(setopt package-archives
        '(("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
          ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
          ("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

;; Initialize package system if not already done.
(unless package--initialized
  (package-initialize))

(defun my-package-refresh-contents ()
  "Refresh package archives."
  (package-refresh-contents))

(defun my-package-ensure-installed (package &optional refresh)
  "Install PACKAGE when needed.
When REFRESH is non-nil, refresh package archives before installing."
  (unless (package-installed-p package)
    (when (or refresh (null package-archive-contents))
      (my-package-refresh-contents))
    (package-install package)))

(defun my-missing-selected-packages ()
  "Return selected packages that are not installed locally."
  (seq-filter
   (lambda (package)
     (not (package-installed-p package)))
   package-selected-packages))

(defun my-install-missing-selected-packages (&optional noerror)
  "Install packages missing from `package-selected-packages'.

When NOERROR is non-nil, report failures as warnings and keep startup going.
This ensures a broken network doesn't block Emacs from starting."
  (let ((missing (my-missing-selected-packages)))
    (when missing
      (condition-case err
          (progn
            ;; Refresh once when something is missing so new machines can bootstrap.
            (my-package-refresh-contents)
            (dolist (package missing)
              (package-install package)))
        (error
         (if noerror
             (display-warning
              'init-package
              (format "Failed to install missing packages (%s): %s"
                      (mapconcat #'symbol-name missing ", ")
                      (error-message-string err))
              :warning)
           (signal (car err) (cdr err))))))
    missing))

(defun my-bootstrap-packages ()
  "Refresh archives and install all currently missing selected packages.

Use this on a new machine or after clearing `elpa/'."
  (interactive)
  (let ((missing (my-missing-selected-packages)))
    (if missing
        (progn
          (my-package-refresh-contents)
          (dolist (package missing)
            (package-install package))
          (message "Installed missing packages: %s"
                   (mapconcat #'symbol-name missing ", ")))
      (message "All selected packages are already installed."))))

(defun my-install-missing-selected-packages-after-startup ()
  "Install missing selected packages after startup settles."
  (unless (or noninteractive (null (my-missing-selected-packages)))
    (run-with-idle-timer
     1 nil
     (lambda ()
       (my-install-missing-selected-packages 'noerror)))))

;; -- Setup use-package --
;; We use `use-package` for declarative configuration.
(my-package-ensure-installed 'use-package t)

(eval-when-compile
  (require 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Automatically try to install missing packages after startup settles.
(add-hook 'emacs-startup-hook #'my-install-missing-selected-packages-after-startup)

(provide 'init-package)

;;; init-package.el ends here
