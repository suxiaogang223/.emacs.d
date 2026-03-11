# 🛠️ Setup & Installation

This guide will walk you through the prerequisites and installation steps to get your Emacs environment running perfectly.

---

## 📦 System Prerequisites

To get the full experience, you need a modern version of Emacs and a few system-level dependencies.

### 1. Emacs Version
- **Emacs 30.0+** is highly recommended.
- It must be compiled with **Native Compilation** (`--with-native-compilation`) and **Tree-sitter** (`--with-tree-sitter`) support.
- *macOS Users*: You can install this via Homebrew: 
  ```bash
  brew install emacs-plus@30 --with-native-comp --with-xwidgets
  ```

### 2. Optional Search Tools
The current default bindings work without extra search binaries. If you want fast CLI search tools available for future workflows, install:
- **ripgrep** (`rg`)
- **fd**
  ```bash
  # macOS
  brew install ripgrep fd
  ```

### 3. Fonts
This configuration defaults to the **Monaco** font (size 130). Ensure it is installed on your system, or change the `custom-set-faces` value in `init.el` to your preferred monospace font (e.g., Fira Code, JetBrains Mono).

---

## 🚀 Installation Steps

### Step 1: Backup
If you already have an Emacs configuration, back it up:
```bash
mv ~/.emacs.d ~/.emacs.d.bak
```

### Step 2: Clone the Repository
Clone this configuration into your home directory:
```bash
git clone https://github.com/suxiaogang223/kanso-emacs.git ~/.emacs.d
```

### Step 3: First Launch & Bootstrap
Start Emacs. The configuration will:
1. Initialize package archives from the Tsinghua (TUNA) mirrors.
2. Install packages required immediately by startup.
3. Schedule any remaining missing packages for installation after startup settles.

**Troubleshooting Network Issues:**
If the initial download fails due to a timeout, simply press `M-x` (Alt + x) and type:
```text
M-x my-bootstrap-packages
```
This will forcefully refresh the package archives and attempt the installation again.

If you want to inspect package drift without changing anything, run:
```text
M-x my-missing-selected-packages
```

---

## 🌲 Tree-sitter Setup

Tree-sitter provides superior, AST-based syntax highlighting. You need to install the grammars for your specific languages. 

Run the following commands interactively in Emacs:
- `M-x my-install-python-treesit-grammar`
- `M-x my-install-rust-treesit-grammar`
- `M-x my-install-c/c++-treesit-grammars`

*Note: You will need a C compiler (like `gcc` or `clang`) on your system to compile these grammars.*
