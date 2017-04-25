require_relative 'current_scores'
require_relative 'player'
require_relative 'team'

class NBA
    def start
        welcome_command
        loop do
            line = gets.strip
            line == '5' ? break : match_input(line)
        end
    end
    def match_input(query)
        case query
        when "1" then player(query)
        when "2" then team(query)
        when "3" then scores
        when "4" then help_command
        else puts "Unknown command. Please try again"
        end
    end
    def player(query)
        puts "Please enter a player's name"
        line = gets.strip
        puts "You've searched for: #{line}"
        puts
        puts "Here's what we've found: "
        puts
        agent = Player.new
        url = agent.find_player_url(line)
        agent.scrape_information(url)
    end

    def team(query)
        puts "Please enter a team's name"
        name = gets.strip
        puts "Please enter a year"
        year = gets.strip
        puts
        puts "Please select from the following options"
        puts "1) Roster"
        puts "2) Team Stats"
        puts "3) Schedule"
        option = gets.strip
        selected_option = ""
        if option == "1"
            selected_option = "Roster"
        elsif option == "2"
            selected_option = "Team Stats"
        elsif option == "3"
            selected_option = "Schedule"
        else
            selected_option = nil
        end
        return if !selected_option
        puts "You've searched for: #{name}, #{year}, #{selected_option}"
        puts
        puts "Here's what we've found: "
        puts
        agent = Team.new
        url = agent.find_team_url(name)
        agent.scrape_information(url, year, selected_option)
    end

    def scores
        CurrentScores.new.print_games
    end

    def welcome_command
        puts
        puts "Welcome to the NBA Stats Tracker"
        puts "Please select from the following options:"
        puts
        puts "1) Find the stats/info for a player"
        puts "2) Find the stats/info for a team"
        puts "3) Find live games, past games, and upcoming games for today"
        puts "4) Help"
        puts "5) Exit"
        puts
    end

    def help_command
        puts "Usage:"
        puts "Enter in this order for Player Statistics (Eg): 1; 'Kyrie Irving'"
        puts "Enter in this order for Team Statistics (Eg): 2; 'Cavaliers'; 2017; 1"
        puts "Enter in this order for Current/Past/Upcoming Games(Eg): 3"
        puts "Enter 5 to exit"
        puts
    end
end

NBA.new.start
