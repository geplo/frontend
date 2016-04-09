// Bootstrap CSS
import 'bootstrap/dist/css/bootstrap';
import 'bootstrap/dist/css/bootstrap-theme';

// App styles in Less
import 'assets/less/app';

// React app
import React        from 'react';
import ReactDOM     from 'react-dom';
import Layout       from './jsx/Layout';

ReactDOM.render(
  <Layout />,
  document.getElementById('root')
);
