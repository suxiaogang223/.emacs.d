;;; lang-rust.el --- Rust configuration -*- lexical-binding: t; -*-

(add-hook 'rust-mode-hook #'eglot-ensure)
(add-hook 'rust-mode-hook #'company-mode)
(add-electric-to-hook 'rust-mode-hook)

(provide 'lang-rust)

;;; lang-rust.el ends here
