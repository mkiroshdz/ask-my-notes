# README

## Summary

A silly app. 

## Requirements 

- Node 12.x
- Ruby 3.2.1

## ENV variables

- MONGO_URI: Uri to connect to your mongodb instance.
- OPENAI_KEY: Key to consume Open Ai api.

## Ingestion

There's a rake task that will be used locally for ingestion of content.

`bundle exec rake ingest:pdf [path of pdf] [pdf of json with data]`

## Local server 

`bundle exec rails s`