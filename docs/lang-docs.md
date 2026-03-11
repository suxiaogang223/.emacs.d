# 📝 Org and Markdown Writing Workflow

The document configuration (`lisp/init-docs.el`) adds a focused writing environment for `org-mode`, `markdown-mode`, and `gfm-mode`. It is designed for technical notes, project documentation, and README authoring rather than a full publishing stack.

---

## ✨ Features

- **Shared Writing UI**: Prose buffers use soft wrapping, hide line numbers, and switch to mixed-pitch text for easier long-form reading.
- **Code-Friendly Layout**: Source blocks, tables, metadata, and inline code stay fixed-pitch so technical documents remain aligned.
- **Org Visual Cleanup**: `org-indent-mode`, native source block highlighting, and `org-modern` make headings and lists easier to scan.
- **Markdown Support**: `.md` files open in `markdown-mode`, while `README.md` uses `gfm-mode`.
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

- Source blocks use native font-lock highlighting.
- TAB inside source blocks follows the language mode behavior.
- Content inside source editing buffers is not indented an extra level.

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
- `org-docs-setup` enables Org-specific behavior on top of the shared UI.
- `markdown-docs-setup` applies the same writing-focused UI to Markdown and GFM buffers.
- Optional enhancements are guarded so startup still succeeds even if packages are temporarily unavailable during installation.
