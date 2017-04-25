# Set up environment variables
ENV['SINATRA_ENV'] ||= 'development'

ENV['SINATRA_DB'] ||= ':memory:' if ENV['SINATRA_ENV'] == 'test'
ENV['SINATRA_DB'] ||= "db/#{ENV['SINATRA_ENV']}.sqlite3"
