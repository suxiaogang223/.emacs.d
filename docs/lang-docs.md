# 📝 Org and Markdown Writing Workflow

The document configuration (`lisp/init-docs.el`) keeps writing support intentionally light. It adds a few practical defaults for `org-mode`, `markdown-mode`, and `gfm-mode` without trying to turn Emacs into a full publishing framework.

---

## ✨ Features

- **Shared Writing UI**: Prose buffers use soft wrapping and hide line numbers.
- **Org Visual Cleanup**: `org-indent-mode` and `org-modern` make headings and lists easier to scan.
- **Markdown Support**: `.md` files open in `markdown-mode`, while `README.md` uses `gfm-mode`.
- **Main-Font Markdown Code Blocks**: Markdown code blocks inherit the main Emacs font instead of forcing a separate fixed-pitch face.
- **Table of Contents Helpers**: `toc-org` is enabled for both Org and Markdown buffers.

---

## 📦 Prerequisites

There are no extra external CLI requirements for the core editing workflow. The required Emacs packages are installed through the normal package bootstrap process:

- `markdown-mode`
- `org-modern`
- `toc-org`

For Markdown preview, `markdown-preview` opens the rendered result in your browser, so you need a working `browse-url` setup on your system.

---

## ⌨️ Daily Workflow & Keybindings

### Org Mode

| Shortcut | Command | Action |
| :--- | :--- | :--- |
| `C-c C-o` | `org-open-at-point` | Open the link or target at point. |
| `C-c C-t` | `org-todo` | Toggle TODO state for the current heading. |
| `C-c C-e` | `org-export-dispatch` | Open Org's export dispatcher. |

Useful defaults that are active automatically:

- Visual line wrapping is enabled.
- Line numbers are disabled in prose buffers.
- Content inside source editing buffers is not indented an extra level.
- `org-indent-mode` is enabled automatically.

### Markdown / GFM

| Shortcut | Command | Action |
| :--- | :--- | :--- |
| `C-c C-o` | `markdown-follow-thing-at-point` | Open the link or reference at point. |
| `C-c C-p` | `markdown-preview` | Render the current buffer and preview it in a browser. |
| `C-c C-t` | `toc-org-mode` | Toggle automatic table-of-contents maintenance. |

`README.md` files automatically use `gfm-mode`, which is better aligned with GitHub-style Markdown.

---

## ⚙️ Under the Hood

- `docs-text-ui` applies the shared prose editing defaults.
- `org-mode` adds `org-indent-mode` on top of the shared UI.
- `README.md` is explicitly mapped to `gfm-mode`.
- `markdown-code-face` is remapped to inherit `default`, so Markdown code blocks match the main editor font.
