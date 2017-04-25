require 'open-uri'
require 'nokogiri'
require 'JSON'
require 'terminal-table'


class CurrentScores

    # get all of the games
    def get_all
        url = 'https://ca.sports.yahoo.com/__xhr/sports/scorestrip-gs/?d=full&b=&format=realtime&league=nba'
        json = JSON.parse(open(url).read)['content']
        doc = Nokogiri::HTML(json)

        # live, final, and upcoming games
        links = doc.css("li[id*=score]")
        # get each of the ids
        games = Hash["Live Games" => [], "Finished Games" => [], "Upcoming Games" => []]
        game_count = 0
        links.each do |link|
            game = link.css('a')[0]['title'].split(": ")
            if game.first == 'Current Score'
                games['Live Games'] << [game_count, game.last, link.css('span[class="period"]').text]
            elsif game.first == 'Preview'
                games['Upcoming Games'] << [game_count, game.last, link.css('em').text]
            else
                games['Finished Games'] << [game_count, game.last, '']
            end
            game_count += 1
        end
        return games
    end


    def print_games
        get_all.each do |key, array|
            puts "#{key}"
            puts "--------"
            unless array.empty?
                array.each do |arr_val|
                    puts "> " + arr_val[1] + " \n" + arr_val[2]
                end
                puts
            else
                puts "No #{key.downcase}"
                puts
            end
        end
    end
end
