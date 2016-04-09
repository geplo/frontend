import React, { Component, PropTypes } from 'react';

class Message extends Component {
  static propTypes = {
    message: PropTypes.string.isRequired,
  };

  constructor(props) {
    super(props);
    this.state = { message: props.message };
  }

  handleChange = e => this.setState({ message: e.target.value });

  render = () => (
    <div className="jumbotron">
      <h1> Hello, { this.state.message }!</h1>
      <p>Boilerplate up and running!</p>
      <span>
        { 'Message: ' }
        <input
          onChange={ this.handleChange }
          value={ this.state.message }
        />
      </span>
    </div>
  );
}

export default Message;
