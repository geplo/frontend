const path = require('path');
const express = require('express');
const webpack = require('webpack');
const config = require('./webpack.config');

const app = express();
const compiler = webpack(config);

app.use(require('webpack-dev-middleware')(compiler, {
  noInfo:       true,
  publicPath:   config.output.publicPath,
  watchOptions: {
    aggregateTimeout: 300,
    poll:             500,
  },
}));

app.use(require('webpack-hot-middleware')(compiler));

app.use('/static', express.static('static'));

app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'static/index.html'));
});

app.listen(process.env.HOST_PORT || 8080, '0.0.0.0', err => {
  if (err) {
    console.log(err);
    return;
  }

  console.log(`Listening at ${process.env.WEB_URL || 'http://localhost:8080'}`);
  console.log('Compiling bundle...');
});
