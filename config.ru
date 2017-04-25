ENV['SINATRA_ENV'] ||= 'development'
Bundler.require(:default, ENV['SINATRA_ENV'])
require_relative 'environment'
require_relative 'database'
Dir.glob('./app/{models}/*.rb').each { |file| require file }
