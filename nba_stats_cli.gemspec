Gem::Specification.new do |spec|
  spec.name          = "nba_stats_cli"
  spec.version       = '0.1.1'
  spec.date        =   '2017-04-25'
  spec.authors       = ["raghavjoshi"]
  spec.email         = ["raghav.joshi.15@gmail.com"]
  spec.summary       = "NBA Statistics CLI tool"
  spec.description   = "A CLI tool for NBA player, team, and game statistics"
  spec.homepage      = 'https://github.com/raghavjoshi/nba_cli'
  spec.license       = "MIT"
  spec.files = ["lib/nba_stats_cli.rb", "lib/nba_stats_cli/cli.rb", "lib/nba_stats_cli/player_scraper.rb", "lib/nba_stats_cli/team_scraper.rb", "lib/nba_stats_cli/current_scores.rb", "environment.rb"]
  spec.executables  = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "pry", ">= 0"
  spec.add_development_dependency "rake", ">= 1.10"
  spec.add_development_dependency "rspec", ">= 3.0"
  spec.add_dependency "nokogiri", ">= 0"
  spec.add_dependency "json", ">=0"
  spec.add_dependency "terminal-table", "1.5.2"
  spec.add_dependency "mechanize", ">=0"
  spec.add_dependency "gruff", ">=0"
  spec.add_dependency "launchy", ">=0"
  spec.add_dependency "simplecov", ">=0"
end
