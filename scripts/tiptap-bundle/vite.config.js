import { defineConfig } from 'vite'

export default defineConfig({
  build: {
    minify: 'esbuild',
    lib: {
      entry: 'src/index.js',
      name: 'TiptapBundle',
      fileName: () => 'tiptap.bundle.js',
      formats: ['es'],
    },
    rollupOptions: {
      external: [],
      output: {
        inlineDynamicImports: true,
        compact: true,
      },
    },
    target: 'es2020',
  },
  esbuild: {
    minify: true,
    legalComments: 'none',         // ✅ strip license/comments
    drop: ['console', 'debugger'], // optional: remove console/debugger
  },
})