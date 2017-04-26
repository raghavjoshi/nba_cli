# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nba_stats_cli/version'

Gem::Specification.new do |spec|
  spec.name          = "nba_stats_cli"
  spec.version       = NbaStatsCli::VERSION
  spec.authors       = ["raghavjoshi"]
  spec.email         = ["raghav.joshi.15@gmail.com"]
  spec.summary       = "NBA Statistics CLI tool"
  spec.description   = "A CLI tool for NBA player, team, and game statistics"
  spec.homepage      = 'https://github.com/raghavjoshi/cis196-final-project'
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://mygemserver.com'
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "pry", ">= 0"
  spec.add_development_dependency "rake", ">= 1.10"
  spec.add_development_dependency "rspec", ">= 3.0"
  spec.add_dependency "nokogiri", ">= 0"
  spec.add_dependency "json", ">=0"
  spec.add_dependency "terminal-table", "1.5.2"
  spec.add_dependency "mechanize", ">=0"
  spec.add_dependency "gruff", ">=0"
end
