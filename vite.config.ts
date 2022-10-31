import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue2'
import RubyPlugin from 'vite-plugin-ruby'
import { createSvgPlugin } from 'vite-plugin-vue2-svg'
import * as path from 'path'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    vue(),
    createSvgPlugin()
  ],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './app/frontend/editor')
    },
  },
})
