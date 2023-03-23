import React from 'react';
import _ from 'underscore';
import TextAnimation from 'react-animate-text';

export default class Book extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      completion: '',
      question: ''
    }
  }

  setQuestion(question) {
    this.setState(
      Object.assign(this.state, { question: question })
    )
  }

  render() {
    return (
      <div className='container p-6'>
        <div className='mb-6'>
          <h3 className='title is-3 has-text-centered'>
            { this.props.title}
          </h3>
          <h4 className='title is-4 has-text-centered'>
            by { this.props.author }
          </h4>
        </div>
        <div className='book-display__cover'>
          <img src={ this.props.cover } />
        </div>
        <p className='has-text-centered'>This is an experiment in using AI to make my book's content more accessible. Ask a question and AI'll answer it in real-time:</p>
        <div className='control'>
          <textarea className='textarea' onChange={(e) => this.setQuestion(e.target.value) } placeholder='Enter your question here'>
          </textarea>
        </div>
        {this.state.question}
        <div className='mt-3'>
          <button className="button is-black">Ask</button>
          <button className="button is-light">I'm feeling lucky</button>
        </div>
        <div className='mt-3'>
          <TextAnimation charInterval={50} animation='type'>{this.state.completion}</TextAnimation>
        </div>
      </div>
    );
  }
}