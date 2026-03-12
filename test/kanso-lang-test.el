;;; kanso-lang-test.el --- Language-specific Kanso tests -*- lexical-binding: t; -*-

;;; Commentary:
;; ERT coverage for deterministic language-module behavior.

;;; Code:

(require 'eglot)
(require 'kanso-test-helper)

(ert-deftest kanso-lang-eglot-registrations ()
  "Language modules should register their language servers."
  (should (equal (assoc '(python-mode python-ts-mode) eglot-server-programs)
                 '((python-mode python-ts-mode) "pyright-langserver" "--stdio")))
  (should (equal (assoc '(rust-mode rust-ts-mode) eglot-server-programs)
                 '((rust-mode rust-ts-mode) "rust-analyzer")))
  (should (equal (assoc '(c++-mode c-mode c-ts-mode c++-ts-mode) eglot-server-programs)
                 '((c++-mode c-mode c-ts-mode c++-ts-mode) . c/c++-clangd-contact))))

(ert-deftest kanso-lang-rust-target-command-selection ()
  "Rust target commands should follow file placement inside Cargo projects."
  (kanso-test-with-project
      '(("Cargo.toml" . "[package]\nname = \"demo\"\nversion = \"0.1.0\"\n")
        ("tests/math.rs" . "")
        ("examples/demo.rs" . "")
        ("benches/bench.rs" . "")
        ("src/main.rs" . ""))
    (let ((buffer-file-name (expand-file-name "tests/math.rs" default-directory)))
      (should (equal (rust-target-command) "cargo test --test math")))
    (let ((buffer-file-name (expand-file-name "examples/demo.rs" default-directory)))
      (should (equal (rust-target-command) "cargo run --example demo")))
    (let ((buffer-file-name (expand-file-name "benches/bench.rs" default-directory)))
      (should (equal (rust-target-command) "cargo bench --bench bench")))
    (let ((buffer-file-name (expand-file-name "src/main.rs" default-directory)))
      (should (equal (rust-target-command) "cargo check")))))

(ert-deftest kanso-lang-cmake-helper-behavior ()
  "CMake helpers should find build directories and compile databases."
  (kanso-test-with-project
      '(("CMakeLists.txt" . "cmake_minimum_required(VERSION 3.20)\nproject(demo)\n")
        ("cmake-build-debug/compile_commands.json" . "[]"))
    (let ((build-dir (expand-file-name "cmake-build-debug" default-directory))
          (compile-db (expand-file-name "cmake-build-debug/compile_commands.json"
                                        default-directory)))
      (should (equal (c/c++-default-build-directory default-directory) build-dir))
      (should (equal (c/c++-find-compile-commands default-directory) compile-db))
      (should (member (format "--compile-commands-dir=%s" build-dir)
                      (c/c++-clangd-contact nil nil)))
      (should (string-match-p "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
                              (c/c++-cmake-configure-command default-directory))))))

(ert-deftest kanso-lang-cmake-build-directory-fallback ()
  "CMake projects without a build dir should default to <root>/build."
  (kanso-test-with-project
      '(("CMakeLists.txt" . "cmake_minimum_required(VERSION 3.20)\nproject(demo)\n"))
    (should (equal (c/c++-default-build-directory default-directory)
                   (expand-file-name "build" default-directory)))
    (should-not (c/c++-find-compile-commands default-directory))))

(provide 'kanso-lang-test)

;;; kanso-lang-test.el ends here
