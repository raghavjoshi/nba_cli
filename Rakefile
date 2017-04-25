require 'fileutils'
require 'bundler'
require_relative 'environment'
Bundler.require(:default, ENV['SINATRA_ENV'])
require_relative 'database'
Dir.glob('./app/{controllers,models}/*.rb').each { |file| require file }

namespace :db do
  desc 'Create the database'
  task :create do
    require 'sqlite3'
    SQLite3::Database.new ENV['SINATRA_DB']
  end

  desc 'Run database migrations'
  task :migrate do
    require_relative 'database'
    ActiveRecord::Tasks::DatabaseTasks.migrate
  end

  desc 'Seed the database with example data'
  task :seed do
    require_relative 'database'
    load File.expand_path('../db/seeds.rb', __FILE__)
  end

  desc 'Drop the database'
  task :drop do
    rm ENV['SINATRA_DB'], force: true
  end
end

task :zip do
  zip_file = 'files.zip'
  files = 'app'
  FileUtils.rm_r zip_file if File.exist? zip_file
  `zip -r #{zip_file} #{files}`
end
