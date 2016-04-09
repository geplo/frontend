const path = require('path');
const webpack = require('webpack');
const production = (process.env.NODE_ENV === 'production');

const bundle = ['./app/index'];
const plugins = [new webpack.optimize.CommonsChunkPlugin('vendor', 'js/vendor.js')];

// Defaults.
const defaults = {
  webURL:    'http://localhost:8080',      // Host of the web server.
  apiURL:    'https://', // Host of the api server.
  debugMode: true,
};

if (production) {
  plugins.unshift(
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: JSON.stringify('production'),
      },
      NODE_ENV:       JSON.stringify('production'),
      __API_URL__:    JSON.stringify(process.env.API_URL || defaults.apiURL),
      __DEBUG_MODE__: JSON.stringify(false),
    }),
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false,
      },
    }),
    new webpack.NoErrorsPlugin()
  );
} else {
  bundle.unshift(
    // listen to code updates emitted by hot middleware
    `webpack-hot-middleware/client?${defaults.webURL}`
  );
  plugins.unshift(
    new webpack.DefinePlugin({
      __API_URL__:    JSON.stringify(process.env.API_URL || defaults.apiURL),
      __DEBUG_MODE__: JSON.stringify(process.env.NODE_DEBUG || defaults.debugMode),
    }),
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin()
  );
}

const webpackConfig = {
  devtool: production ? 'source-map' : 'cheap-module-eval-source-map',
  entry:   {
    bundle,
    vendor: ['react'],
  },
  output: {
    path:       path.join(__dirname, 'static/'),
    filename:   'js/[name].js',
    publicPath: '/static/',
  },
  plugins,
  resolve: {
    alias: {
      assets: path.join(__dirname, 'app/'),
    },
    extensions: ['', '.js', '.jsx', '.es6', '.less', '.css'],
  },
  module: {
    loaders: [
      {
        test:    /\.(js|jsx|es6)$/,
        loaders: ['babel'],
        exclude: /node_modules/,
      },
      {
        test:   /\.(less)$/,
        loader: 'style!css!less',
      },
      {
        test:   /\.(css)$/,
        loader: 'style!css',
      },
      {
        test:   /\.(ttf|eot|svg|woff|woff2)$/,
        loader: 'file?name=fonts/[name].[ext]',
      },
      {
        test:   /\.(png|gif|jpg)$/,
        loader: 'file?name=images/[name].[ext]',
      },
    ],
  },
};

module.exports = webpackConfig;
