# 🚀 Minimalist Emacs Configuration

<div align="center">

[![Emacs Version](https://img.shields.io/badge/Emacs-30.0+-blueviolet.svg?style=for-the-badge&logo=gnu-emacs&logoColor=white)](https://www.gnu.org/software/emacs/)
[![Documentation](https://img.shields.io/badge/Docs-GitHub%20Pages-blue.svg?style=for-the-badge&logo=github)](https://<your-username>.github.io/emacs-d/)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

*A high-performance, modular, and modern Emacs configuration tailored for software engineering.*<br>
*Built to leverage native features like `eglot` and `tree-sitter` for a full IDE experience without the bloat.*

</div>

---

## 📖 Documentation

Comprehensive guides, setup instructions, and language-specific workflows are available on our **[Documentation Site](https://<your-username>.github.io/emacs-d/)**.

### 🔗 Quick Links
- **[Getting Started & Installation](docs/setup.md)**
- **[🐍 Python Development](docs/lang-python.md)**
- **[🦀 Rust Development](docs/lang-rust.md)**
- **[❄️ C/C++ Development](docs/lang-cc.md)**
- **[🎾 Racket Development](docs/lang-racket.md)**

---

## ✨ Design Philosophy

1. **Native First**: Prioritize built-in Emacs features (`eglot`, `project.el`, `treesit`) over heavy third-party frameworks.
2. **Lightning Fast**: Lazy-loading and a modular architecture ensure sub-second startup times.
3. **Discoverable**: Powered by a modern completion stack (`Vertico`, `Consult`, `Marginalia`, `Orderless`) to make finding files, commands, and code effortless.
4. **Resilient**: Intelligent package bootstrapping ensures a smooth setup on any new machine, even with spotty network connections.

---

## 📂 Architecture

The configuration is strictly modular, keeping `init.el` clean and declarative.

```text
~/.emacs.d/
├── init.el                 # 🏁 Core settings and module loader
├── lisp/                   # 🏗️ Configuration modules
│   ├── init-package.el     # 📦 Package management & auto-bootstrap
│   ├── init-completion.el  # 🔍 Vertico, Consult, Marginalia stack
│   ├── init-editing.el     # ✍️ Global editing behaviors
│   ├── init-tools.el       # 🛠️ Magit, Company, Eglot
│   ├── init-ui.el          # 💄 Theming and visual decluttering
│   └── lang-*.el           # 🌐 Language-specific environments
└── docs/                   # 📖 Documentation source
```

---

## 🚀 Quick Start

Ensure you have **Emacs 30.0+** installed, then simply clone and run:

```bash
# 1. Backup existing config (if any)
mv ~/.emacs.d ~/.emacs.d.bak

# 2. Clone the repository
git clone https://github.com/suxiaogang223/.emacs.d.git ~/.emacs.d

# 3. Launch Emacs
emacs
```

*Emacs will automatically download and install required packages upon the first launch.*

---

## 📝 License

This configuration is open-source and available under the [MIT License](LICENSE). Feel free to fork, modify, and use it as the foundation for your own setup.
