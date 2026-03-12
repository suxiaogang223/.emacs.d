;;; lang-cc.el --- C and C++ configuration -*- lexical-binding: t; -*-

(require 'compile)
(require 'project)

(defconst c/c++-cmake-build-directories
  '("build" "cmake-build-debug" "cmake-build-release" "out/build")
  "Common CMake build directories to probe from a project root.")

(defun enable-c-ts-modes ()
  "Prefer tree-sitter C and C++ modes when grammars are available."
  (when (and (fboundp 'treesit-available-p)
             (treesit-available-p)
             (fboundp 'treesit-language-available-p))
    (when (treesit-language-available-p 'c)
      (add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode)))
    (when (treesit-language-available-p 'cpp)
      (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode)))))

(defun install-c/c++-treesit-grammars ()
  "Install tree-sitter grammars for C and C++."
  (interactive)
  (unless (and (fboundp 'treesit-available-p) (treesit-available-p))
    (user-error "Tree-sitter is not available in this Emacs"))
  (add-to-list 'treesit-language-source-alist
               '(c "https://github.com/tree-sitter/tree-sitter-c"))
  (add-to-list 'treesit-language-source-alist
               '(cpp "https://github.com/tree-sitter/tree-sitter-cpp"))
  (treesit-install-language-grammar 'c)
  (treesit-install-language-grammar 'cpp)
  (enable-c-ts-modes)
  (message "Installed tree-sitter grammars for C and C++"))

(defun format-c/c++-buffer ()
  "Format the current C or C++ buffer with clang-format."
  (interactive)
  (when (derived-mode-p 'c-mode 'c++-mode 'c-ts-mode 'c++-ts-mode)
    (unless (executable-find "clang-format")
      (user-error "Executable `clang-format' not found in PATH"))
    (let ((point-pos (point)))
      (shell-command-on-region
       (point-min) (point-max)
       "clang-format"
       (current-buffer) t "*clang-format*")
      (goto-char (min point-pos (point-max))))))

(defun c/c++-project-root ()
  "Return the current C or C++ project root."
  (or (when-let ((project (project-current nil)))
        (project-root project))
      default-directory))

(defun c/c++-find-build-directory (root)
  "Return a CMake build directory under ROOT, if one exists."
  (seq-find
   #'file-directory-p
   (mapcar (lambda (dir)
             (expand-file-name dir root))
           c/c++-cmake-build-directories)))

(defun c/c++-find-compile-commands (root)
  "Return the path to `compile_commands.json' for ROOT, if one exists."
  (let ((root-db (expand-file-name "compile_commands.json" root))
        (build-dir (c/c++-find-build-directory root)))
    (cond
     ((file-exists-p root-db) root-db)
     (build-dir
      (let ((build-db (expand-file-name "compile_commands.json" build-dir)))
        (when (file-exists-p build-db)
          build-db))))))

(defun c/c++-cmake-root (root)
  "Return the nearest CMake project root from ROOT, if any."
  (locate-dominating-file root "CMakeLists.txt"))

(defun c/c++-default-build-directory (root)
  "Return the preferred build directory for the CMake project at ROOT."
  (or (c/c++-find-build-directory root)
      (expand-file-name "build" root)))

(defun c/c++-cmake-configure-command (root)
  "Return a configure command for the CMake project at ROOT."
  (let ((build-dir (c/c++-default-build-directory root)))
    (format "cmake -S %s -B %s -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
            (shell-quote-argument root)
            (shell-quote-argument build-dir))))

(defun c/c++-cmake-build-command (root)
  "Return a build command for the CMake project at ROOT."
  (format "cmake --build %s"
          (shell-quote-argument (c/c++-default-build-directory root))))

(defun c/c++-clangd-contact (_interactive _project)
  "Return a `clangd' contact spec with an optional compile database directory."
  (let* ((root (c/c++-project-root))
         (compile-db (c/c++-find-compile-commands root)))
    (append
     (list "clangd")
     (when compile-db
       (list (format "--compile-commands-dir=%s"
                     (directory-file-name
                      (file-name-directory compile-db))))))))

(defun c/c++-single-file-output ()
  "Return the default output path for the current translation unit."
  (when buffer-file-name
    (expand-file-name
     (file-name-sans-extension
      (file-name-nondirectory buffer-file-name))
     default-directory)))

(defun c/c++-set-compile-command ()
  "Populate a sensible per-buffer compile command for C and C++."
  (let* ((root (c/c++-project-root))
         (make-root (or (locate-dominating-file root "Makefile")
                        (locate-dominating-file root "makefile")
                        (locate-dominating-file root "GNUmakefile")))
         (cmake-root (c/c++-cmake-root root))
         (compile-db (and cmake-root (c/c++-find-compile-commands cmake-root))))
    (setq-local compile-command
                (cond
                 (make-root
                  (format "make -k -C %s"
                          (shell-quote-argument make-root)))
                 (compile-db
                  (c/c++-cmake-build-command cmake-root))
                 (cmake-root
                  (format "%s && %s"
                          (c/c++-cmake-configure-command cmake-root)
                          (c/c++-cmake-build-command cmake-root)))
                 (buffer-file-name
                  (format "%s %s -o %s"
                          (if (derived-mode-p 'c-mode 'c-ts-mode)
                              "clang -std=c17 -Wall -Wextra"
                            "clang++ -std=c++20 -Wall -Wextra")
                          (shell-quote-argument buffer-file-name)
                          (shell-quote-argument (c/c++-single-file-output))))
                 (t compile-command)))))

(defun c/c++-run ()
  "Run the current single-file C or C++ binary."
  (interactive)
  (let ((binary (c/c++-single-file-output)))
    (unless (and binary (file-executable-p binary))
      (user-error "No executable found at %s; compile first" binary))
    (compile (shell-quote-argument binary) t)))

(defun c/c++-configure-cmake ()
  "Configure the current CMake project and export `compile_commands.json'."
  (interactive)
  (let ((root (c/c++-cmake-root (c/c++-project-root))))
    (unless root
      (user-error "No CMake project found"))
    (compile (c/c++-cmake-configure-command root))))

(defun c/c++-setup ()
  "Set up development helpers for C and C++ buffers."
  (eglot-ensure)
  (enable-company-mode-if-available)
  (c/c++-set-compile-command))

(add-to-list 'eglot-server-programs
             `((c++-mode c-mode c-ts-mode c++-ts-mode)
               . ,#'c/c++-clangd-contact))
(enable-c-ts-modes)
(dolist (hook '(c-mode-hook c++-mode-hook c-ts-mode-hook c++-ts-mode-hook))
  (add-hook hook #'c/c++-setup)
  (add-electric-to-hook hook))

(with-eval-after-load 'cc-mode
  (define-key c-mode-base-map (kbd "C-c C-c") #'compile)
  (define-key c-mode-base-map (kbd "C-c C-k") #'recompile)
  (define-key c-mode-base-map (kbd "C-c C-f") #'format-c/c++-buffer)
  (define-key c-mode-base-map (kbd "C-c C-m") #'c/c++-configure-cmake)
  (define-key c-mode-base-map (kbd "C-c C-r") #'c/c++-run))

(provide 'lang-cc)

;;; lang-cc.el ends here
