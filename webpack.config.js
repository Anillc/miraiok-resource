module.exports = {
  mode: 'production',
  target: 'node',
  entry: './src/index.coffee',
  module: {
    rules: [
      {
        test: /\.coffee$/,
        loader: 'coffee-loader'
      }
    ]
  }
};
