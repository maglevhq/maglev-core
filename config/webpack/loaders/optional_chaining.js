module.exports = {
  test: /\.vue(\.erb)?$/,
  exclude: /node_modules/,
  loader: 'babel-loader',
  options: {
    plugins: [
      require('@babel/plugin-proposal-optional-chaining'),
    ],
  }
}