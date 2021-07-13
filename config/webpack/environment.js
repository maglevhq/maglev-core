const path = require('path')
const { environment } = require('@rails/webpacker')

// VueJS
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')
environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)

// OptionalChaining
const babelLoader = environment.loaders.get('babel')
babelLoader.use[0].options.plugins = ['@babel/plugin-proposal-optional-chaining', '@babel/plugin-proposal-class-properties'];
    
const customConfig = {
  resolve: {
    alias: {
      '@': path.resolve(__dirname, '..', '..', 'app/javascript/editor')
    }
  },
  module: {
    rules: [
      {
        test: /\.svg$/,
        use: ['vue-loader', 'vue-svg-loader'],
      },
      {
        enforce: 'pre',
        test: /\.(js|vue)$/,
        loader: 'eslint-loader',
        exclude: /node_modules/
      }
    ],    
  },  
}

environment.config.merge(customConfig)

module.exports = environment
