# Tiptap Bundle (v3.6.2)

This project bundles [Tiptap 3.6.2](https://tiptap.dev/) and its ProseMirror dependencies into a single ES module (`tiptap.bundle.js`) using [Vite](https://vitejs.dev/). It's designed to be used in environments like **Rails with Importmap**, where dynamic module loading or modern bundlers aren't available at runtime.

## Why?

Tiptap v3 relies on many internal ProseMirror packages (`@tiptap/pm/...`) which make it hard to use directly via CDNs or bundlers like `esm.sh`. This project solves that by bundling everything into one self-contained JavaScript file.

## Features

- Includes core Tiptap packages + selected extensions (see below)
- Output: Single `tiptap.bundle.js` (ES module)
- No external dependencies
- Minified and stripped of comments

## Included Extensions

The bundle includes:

- `@tiptap/core`
- `@tiptap/extension-blockquote`
- `@tiptap/extension-bold`
- `@tiptap/extension-code-block`
- `@tiptap/extension-document`
- `@tiptap/extension-hard-break`
- `@tiptap/extension-heading`
- `@tiptap/extension-history`
- `@tiptap/extension-italic`
- `@tiptap/extension-link`
- `@tiptap/extension-list`
- `@tiptap/extension-paragraph`
- `@tiptap/extension-strike`
- `@tiptap/extension-superscript`
- `@tiptap/extension-text`
- `@tiptap/extension-underline`

## Usage

Once built, copy `dist/tiptap.bundle.js` into your asset directory (e.g., `app/assets/javascripts/vendor/` in Rails).

Then import it using ES module syntax:

```html
<script type="module">
  import {
    Editor,
    Bold,
    Italic,
    Paragraph,
    // ... your needed extensions
  } from './tiptap.bundle.js'

  const editor = new Editor({
    element: document.querySelector('#editor'),
    extensions: [
      Paragraph,
      Bold,
      Italic,
    ],
    content: '<p>Hello Tiptap!</p>',
  })
</script>

## Build

```
yarn install
yarn generate
```