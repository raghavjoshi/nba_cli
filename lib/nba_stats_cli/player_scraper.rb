class NbaStatsCli::PlayerScraper
    # search for player's url
    def find_player_url(query)
        base_url = "http://www.basketball-reference.com/search/search.fcgi?search="
        agent = Mechanize.new
        doc = Nokogiri::HTML(open(base_url+"#{query.gsub(/\s/, '+')}"))
        # see if there are no results found
        text_found = doc.xpath('//div[@id="content"]//strong[text()="0 hits"]')
        if text_found.empty?
            page = agent.get(base_url+"#{query.gsub(/\s/, '+')}").links_with(:href => /.html/)
            return page[0].uri
        else
            return nil
        end
    end

    # scrape player's information
    def scrape_information(player_url, graph_opt)
        if player_url.nil?
            puts "No player found"
            return
        end
        # Navigate to player's page and instantiate containers for statistics
        base_url = "http://www.basketball-reference.com#{player_url}"
        doc = Nokogiri::HTML(open(base_url))
        collected, player_age, two_point, three_point, efg, orb, drb, stl, blk = Array.new(9) { [] }

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
            player_age << row.at_xpath('td[1]//text()').to_s.strip
            three_point << row.at_xpath('td[13]//text()').to_s.strip
            two_point << row.at_xpath('td[16]//text()').to_s.strip
            efg << row.at_xpath('td[17]//text()').to_s.strip
            orb << row.at_xpath('td[21]//text()').to_s.strip
            drb << row.at_xpath('td[22]//text()').to_s.strip
            stl << row.at_xpath('td[25]//text()').to_s.strip
            blk << ('td[26]//text()').to_s.strip
            collected << [row.at_xpath('td[1]//text()').to_s.strip,         #age
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
            'GS', 'FG', 'FGA', 'FG%', '3P', '3PA', '3P%', '2P',
            '2PA', '2P%', 'eFG%', 'FT', 'FTA', 'FT%','ORB', 'DRB', 'TRB', 'AST', 'STL', 'BLK',
            'TOV','PF', 'PTS'], :rows => collected

        puts table_out

        case graph_opt
        when 1 then graph_player_shooting(name.to_s, player_age, two_point, three_point, efg)
        when 2 then graph_player_defensive(name.to_s, player_age, orb, drb, stl, blk)
        else puts " "
        end
        return true
    end

    def graph_player_shooting(name, age_lst, two_point_lst, three_point_lst, efg_lst)
        # Instantiate Gruff and set label
        g = Gruff::Line.new
        g.title = "#{name} Shooting Statistics"

        # Get Float values from string
        two_point_lst = two_point_lst.flatten.collect { |i| i.to_f * 100}
        three_point_lst = three_point_lst.flatten.collect { |i| i.to_f * 100}
        efg_lst = efg_lst.flatten.collect { |i| i.to_f * 100}

        # Set labels and graph data
        g.labels = Hash[(0...age_lst.size).zip age_lst]
        g.data("2P%", two_point_lst)
        g.data("3P%", three_point_lst)
        g.data("EFG%", efg_lst)

        # See if directory exists
        unless File.exists?("img/")
            FileUtils::mkdir_p 'img/'
        end

        # Write data to folder and open image
        g.write("img/#{name.downcase}_offensive.png")
        Launchy.open("img/#{name.downcase}_offensive.png")
    end


    def graph_player_defensive(name, age_lst, orb_lst, drb_lst, stl_lst, blk_lst)
        # Instantiate Gruff and set label
        g = Gruff::Line.new
        g.title = "#{name} Defensive Statistics"

        # Get Float values from string
        orb_lst = orb_lst.flatten.collect { |i| i.to_f }
        drb_lst = drb_lst.flatten.collect { |i| i.to_f }
        stl_lst = stl_lst.flatten.collect { |i| i.to_f }
        blk_lst = blk_lst.flatten.collect { |i| i.to_f }

        # Set labels and graph data
        g.labels = Hash[(0...age_lst.size).zip age_lst]
        g.data("Offensive Reb.", orb_lst)
        g.data("Defensive Reb.", drb_lst)
        g.data("Steals", stl_lst)
        g.data("Blocks", blk_lst)

        # See if directory exists
        unless File.exists?("img/")
            FileUtils::mkdir_p 'img/'
        end

        # Write data to folder and open image
        g.write("img/#{name.downcase}_defensive.png")
        Launchy.open("img/#{name.downcase}_defensive.png")
    end

end
