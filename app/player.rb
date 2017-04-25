require 'mechanize'
require 'open-uri'
require 'nokogiri'
require 'terminal-table'

class Player
    # search for player's url
    def find_player_url(query)
        base_url = "http://www.basketball-reference.com/search/search.fcgi?search="
        agent = Mechanize.new
        doc = Nokogiri::HTML(open(base_url+format_query(query)))
        # see if there are no results found
        text_found = doc.xpath('//div[@id="content"]//strong[text()="0 hits"]')
        if text_found.empty?
            page = agent.get(base_url+format_query(query)).links_with(:href => /.html/)
            return page[0].uri
        else
            return nil
        end
    end

    # scrape player's information
    def scrape_information(player_url)
        if player_url.nil?
            puts "No player found"
            return
        end
        base_url = "http://www.basketball-reference.com#{player_url}"
        doc = Nokogiri::HTML(open(base_url))
        collected = []
        # get name
        name = doc.xpath('//h1[@itemprop="name"]/text()')

        # get position and shooting hand
        position = doc.xpath('//div[@itemtype="http://schema.org/Person"]//p[contains(strong/text(),"Position")]')
        position.css("p").each do |t|
            puts t.text.gsub(/\s+/, " ").strip
        end
        #  Get height and weight
        body = doc.xpath('//div[@itemtype="http://schema.org/Person"]//p[contains(span/@itemprop,"height")]')
        height = body.css("span[@itemprop='height']").text.gsub(/\s+/, " ").strip
        weight = body.css("span[@itemprop='weight']").text.gsub(/\s+/, " ").strip
        puts ["Height:", height, "Weight:", weight].join('  ')

        # Get team
        team = doc.xpath('//div[@itemtype="http://schema.org/Person"]//p[contains(strong/text(),"Team")]/a')
        puts ["Team:", team.text].join('  ')
        puts
        puts "Statistics for: #{name}"
        rows = doc.xpath('//tr[@class="full_table"]')
        rows.each do |row|
            collected << [row.at_xpath('td[1]//text()').to_s.strip,
                          row.at_xpath('td[2]/a//text()').to_s.strip,
                          row.at_xpath('td[4]//text()').to_s.strip,
                          row.at_xpath('td[5]//text()').to_s.strip,
                          row.at_xpath('td[6]//text()').to_s.strip,
                          row.at_xpath('td[8]//text()').to_s.strip,
                          row.at_xpath('td[9]//text()').to_s.strip,
                          row.at_xpath('td[10]//text()').to_s.strip,
                          row.at_xpath('td[11]//text()').to_s.strip,
                          row.at_xpath('td[12]//text()').to_s.strip,
                          row.at_xpath('td[13]//text()').to_s.strip,
                          row.at_xpath('td[14]//text()').to_s.strip,
                          row.at_xpath('td[15]//text()').to_s.strip,
                          row.at_xpath('td[16]//text()').to_s.strip,
                          row.at_xpath('td[17]//text()').to_s.strip,
                          row.at_xpath('td[18]//text()').to_s.strip,
                          row.at_xpath('td[19]//text()').to_s.strip,
                          row.at_xpath('td[20]//text()').to_s.strip,
                          row.at_xpath('td[21]//text()').to_s.strip,
                          row.at_xpath('td[22]//text()').to_s.strip,
                          row.at_xpath('td[23]//text()').to_s.strip,
                          row.at_xpath('td[24]//text()').to_s.strip,
                          row.at_xpath('td[25]//text()').to_s.strip,
                          row.at_xpath('td[26]//text()').to_s.strip,
                          row.at_xpath('td[27]//text()').to_s.strip,
                          row.at_xpath('td[28]//text()').to_s.strip,
                          row.at_xpath('td[29]//text()').to_s.strip
        ]
        end

        table_out = Terminal::Table.new :headings => ['Age', 'Team', 'Pos.', 'G',
            'GS', 'Min.', 'FG', 'FGA', 'FG%', '3P', '3PA', '3P%', '2P',
            '2PA', '2P%', 'eFG%', 'FT', 'FT%','ORB', 'DRB', 'TRB', 'AST', 'STL', 'BLK',
            'TOV','PF', 'PTS'], :rows => collected

        puts table_out
    end

    def format_query(query)
        "#{query.gsub(/\s/, '+')}"
    end

end
