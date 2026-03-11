;;; init-package.el --- Package bootstrap -*- lexical-binding: t; -*-

(require 'seq)
(require 'package)

(setopt package-archives
        '(("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
          ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
          ("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

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

When NOERROR is non-nil, report failures as warnings and keep startup going."
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

(my-package-ensure-installed 'use-package t)

(eval-when-compile
  (require 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)
(my-install-missing-selected-packages 'noerror)

(provide 'init-package)

;;; init-package.el ends here
