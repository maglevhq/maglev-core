#!/bin/bash
set -e

echo "🔧 Building with Vite..."
yarn build

echo "🧹 Minifying with Terser..."
npx terser dist/tiptap.bundle.js \
  --compress --mangle --format comments=false \
  -o dist/tiptap.bundle.min.js

echo "👾 Replacing the tiptap bundle in the Maglev engine"
cp dist/tiptap.bundle.min.js ../../vendor/javascript/maglev/tiptap.bundle.js

echo "✅ Done. Output: dist/tiptap.bundle.min.js"
ls -lh dist/tiptap.bundle.min.js