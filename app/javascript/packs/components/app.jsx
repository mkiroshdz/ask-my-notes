
import _ from 'underscore';
import axios from 'axios';
import React from 'react';
import TextAnimation from 'react-animate-text';


export default class Book extends React.Component {
  constructor(props) {
    super(props);
    this.state = { completion: '', question: '' }
  }

  setQuestion(question) {
    this.setState({ ...this.state, question: question })
  }

  requestCompletion(question) {
    if(question.length > 15) {
      this.setState({ ...this.state, completion: '' })

      axios
        .get(`/books/${this.props.slug}/ask?query=${question}`)
        .then((response) => {
          this.setState({
            ...this.state, 
            completion: response.data.completions.join(' '), 
            question: question 
          })
        });
    }
  }

  sendRandomQuestion() {
    this.requestCompletion(_.sample(this.props.questions));
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
          <textarea value={this.state.question} className='textarea' onChange={(e) => this.setQuestion(e.target.value) } placeholder='Enter your question here'>
          </textarea>
        </div>
        <div className='mt-3'>
          <button className="button is-black" onClick={ () => this.requestCompletion(this.state.question) }>Ask</button>
          <button className="button is-light" onClick={ () => this.sendRandomQuestion() }>I'm feeling lucky</button>
        </div>
        <div className='mt-3'>
          { getTextAnimation(this.state.completion) }
        </div>
      </div>
    );
  }
}

function getTextAnimation(completion) {
  if(completion.length > 0) {
    return <TextAnimation charInterval={50} animation='type'>{completion}</TextAnimation>
  }
  return null;
}