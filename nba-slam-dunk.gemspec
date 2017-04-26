GEM::Specification.new do |s|
    s.name = 'nba-slam-dunk'
    s.version = '0.0.0'
    s.date = '2017-04-24'
    s.summary = "A CLI tool for NBA player, team, and game statistics"
    s.description = "A CLI tool for NBA player, team, and game statistics"
    s.authors = ["Raghav Joshi"]
    s.email = 'raghav.joshi.15@gmail.com'
    s.files = ["app/cli.rb", "app/current_scores.rb", "app/player.rb", "app/team.rb",
                "Gemfile", "README.md"]
    s.homepage = 'https://github.com/raghavjoshi/nba_cli'
    s.license = 'MIT'
end
