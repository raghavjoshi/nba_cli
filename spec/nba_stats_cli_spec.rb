require "spec_helper"

RSpec.describe NbaStatsCli do
    agent = NbaStatsCli::PlayerScraper.new
    curr_scores = NbaStatsCli::CurrentScores.new
    team = NbaStatsCli::TeamScraper.new

  it "has a real player named kyrie irving" do
    expect(agent.find_player_url("Kyrie Irving")).not_to be nil
  end
  it "has a partial player named kyrie" do
    expect(agent.find_player_url("Kyrie")).not_to be nil
  end
  it "K has a default player named kobe " do
    expect(agent.find_player_url("K")).not_to be nil
  end
  it "Empty string is nil" do
    expect(agent.find_player_url(" ")).to be_nil
  end
  it "Scraping information about url that doesn't exist has to be nil" do
    expect(agent.scrape_information(agent.find_player_url("www.basketball-reference.com/players/j/jamesle01.html"), 3)).to be_nil
  end

  it "Scraping information about url that doesn't exist has to be nil option 2" do
    expect(agent.scrape_information(agent.find_player_url("www.basketball-reference.com/players/j/jamesle01.html"), 2)).to be_nil
  end
  it "Scraping information about url that doesn't exist has to be nil option 1" do
    expect(agent.scrape_information(agent.find_player_url("www.basketball-reference.com/players/j/jamesle01.html"), 1)).to be_nil
  end
  it "Lebron James has shooting graph 1" do
    expect(agent.scrape_information(agent.find_player_url("Lebron James"), 1)).not_to be nil
  end
  it "Lebron James has defensive graph 2" do
    expect(agent.scrape_information(agent.find_player_url("Lebron James"), 2)).not_to be nil
  end
  it "Lebron James has no graph 0 " do
    expect(agent.scrape_information(agent.find_player_url("Lebron James"), 0)).not_to be nil
  end

  #####
  it "has a real team named cleveland" do
    expect(team.find_team_url("Cleveland")).not_to be nil
  end
  it "has a partial team named Cle" do
    expect(team.find_team_url("Cle")).not_to be nil
  end
  it "C has a default team " do
    expect(team.find_team_url("K")).not_to be nil
  end
  it "Empty string is nil" do
    expect(team.find_team_url(" ")).to be_nil
  end
  it "Scraping information about url that doesn't exist has to be nil" do
    expect(team.scrape_information(agent.find_player_url("www.basketball-reference.com/players/j/jamesle01.html"), 2017, "Roster")).to be_nil
  end
  it "Scraping information about url that doesn't exist has to be nil" do
    expect(team.scrape_information(agent.find_player_url("www.basketball-reference.com/players/j/jamesle01.html"), 2017, "Team Stats")).to be_nil
  end
  it "Scraping information about url that doesn't exist has to be nil" do
    expect(team.scrape_information(agent.find_player_url("www.basketball-reference.com/players/j/jamesle01.html"), 2017, "Else")).to be_nil
  end

end
