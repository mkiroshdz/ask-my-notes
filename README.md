# Ask My Notes

Ask-my-notes is a silly and funny web app that allows you to make questions about the content ingested using pdf documents. This app relies on a language model from OpenAi to be able to understand the meaning of the question given the ingested information.

## Requirements 

- Node 12.x
- Ruby 3.2.1

## ENV variables

- MONGO_URI: Uri to connect to your mongodb instance.
- OPENAI_KEY: Key to consume Open Ai api.

## Ingestion of PDFs

There's a rake task that will be used locally for ingestion of content.

`bundle exec rake ingest:pdf [path of pdf] [pdf or json with data]`

## Local server 

`bundle exec rails s`
