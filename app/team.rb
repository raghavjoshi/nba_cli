require 'mechanize'
require 'open-uri'
require 'nokogiri'
require 'terminal-table'

class Team
    def find_team_url(query)
        base_url = "http://www.basketball-reference.com/search/search.fcgi?search="
        agent = Mechanize.new
        doc = Nokogiri::HTML(open(base_url+format_query(query)))
        text_found = doc.xpath('//div[@id="content"]//strong[text()="0 hits"]')
        if text_found.empty?
            page = doc.xpath('//div[@class="search-item-name"]/strong/a/@href')[0]
            return page.text
        else
            return nil
        end
    end

    # Scrape Information based on option
    def scrape_information(team_url, year, selected_option)
        if team_url.nil? || team_url.include?("player")
            puts "No team found"
            return
        end
        base_url = "http://www.basketball-reference.com#{team_url}"

        # select url based on selected_option
        if selected_option == "Roster"
            find_roster(base_url + year + ".html")
        elsif selected_option == "Team Stats"
            find_stats(base_url + year + ".html")
        else
            find_schedule(base_url + year + "_games.html")
        end

    end

    def find_roster(url)
        doc = Nokogiri::HTML(open(url))
        rows = doc.xpath('//div[@id="div_roster"]//tr')
        name = doc.xpath('//a[@itemprop="item"]/span')[1].text
        puts "Roster for: #{name}"
        collected = []
        rows.each do |row|
            collected << [
                row.at_xpath('th[@data-stat="number"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="player"]/a/text()').to_s.strip,
                row.at_xpath('td[@data-stat="pos"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="height"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="weight"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="birth_date"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="college_name"]/a/text()').to_s.strip
                ]
        end
        table_out = Terminal::Table.new :headings => ['No.', 'Name', 'Pos.', 'Height',
            'Weight', 'DOB', 'College'], :rows => collected
        puts table_out
    end

    def find_stats(url)
        doc = Nokogiri::HTML(open(url))
        name = doc.xpath('//a[@itemprop="item"]/span')[1].text
        puts "Per Game Statistics for: #{name}"
        doc.xpath('//comment()').each { |comment| comment.replace(comment.text) }
        rows = doc.xpath('//table[@id="per_game"]//tr')
        collected = []
        rows.each do |row|
            collected << [
                row.at_xpath('td[@data-stat="player"]/a/text()').to_s.strip,
                row.at_xpath('td[@data-stat="age"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="g"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="gs"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="mp_per_g"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="fg_per_g"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="fga_per_g"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="fg_pct"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="fg3_per_g"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="fg3a_per_g"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="fg3_pct"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="fg2_per_g"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="fg2a_per_g"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="fg2_pct"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="efg_pct"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="ft_per_g"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="fta_per_g"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="ft_pct"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="orb_per_g"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="drb_per_g"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="ast_per_g"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="stl_per_g"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="blk_per_g"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="tov_per_g"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="pf_per_g"]/text()').to_s.strip,
                row.at_xpath('td[@data-stat="pts_per_g"]/text()').to_s.strip
                ]
        end
        table_out = Terminal::Table.new :headings => ['Player', 'Age', 'G', 'GS',
            'MP', 'FG', 'FGA', 'FG %', 'FG3', 'FG3A',
            'FG3 %', 'FG2', 'FG2A', 'FG2', 'EFG %', 'FT',
            'FTA', 'FT %', 'ORB', 'DRB', 'AST',
            'STL', 'BLK', 'TOV', 'PER', 'PTS'], :rows => collected
        puts table_out
    end

    def find_schedule(url)
        doc = Nokogiri::HTML(open(url))
        rows = doc.xpath('//table[@id="games"]//tr')
        collected = []
        puts "Regular Season Games: "
        rows.each do |row|
            collected << [
                row.at_xpath('th[@data-stat="g"]//text()').to_s.strip,
                row.at_xpath('td[@data-stat="date_game"]/a//text()').to_s.strip,
                row.at_xpath('td[@data-stat="game_start_time"]//text()').to_s.strip,
                row.at_xpath('td[@data-stat="game_location"]//text()').to_s.strip,
                row.at_xpath('td[@data-stat="opp_name"]/a//text()').to_s.strip,
                row.at_xpath('td[@data-stat="game_result"]//text()').to_s.strip,
                row.at_xpath('td[@data-stat="overtimes"]//text()').to_s.strip,
                row.at_xpath('td[@data-stat="pts"]//text()').to_s.strip,
                row.at_xpath('td[@data-stat="opp_pts"]//text()').to_s.strip,
                row.at_xpath('td[@data-stat="wins"]//text()').to_s.strip,
                row.at_xpath('td[@data-stat="losses"]//text()').to_s.strip,
                row.at_xpath('td[@data-stat="game_streak"]//text()').to_s.strip
                ]
        end
        table_out = Terminal::Table.new :headings => ['G#', 'Date', 'Time', 'Loc.',
            'Opp.', 'Result', 'OT', 'PTS', 'OPP PTS', 'W', 'L', 'Streak'], :rows => collected
        puts table_out
    end

    def format_query(query)
        "#{query.gsub(/\s/, '+')}"
    end
end
