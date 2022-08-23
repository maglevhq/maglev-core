import * as path from 'path'
import { defineConfig } from 'vite'

import RubyPlugin from 'vite-plugin-ruby'
import vue from '@vitejs/plugin-vue'
import { viteRequire } from 'vite-require'
import svgLoader from 'vite-svg-loader'

export default defineConfig({
  plugins: [RubyPlugin(), vue(), viteRequire(), svgLoader()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './app/javascript/editor'),
      vue: 'vue/dist/vue.esm-bundler.js',
    },
  },
})
