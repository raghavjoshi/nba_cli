require "spec_helper"

RSpec.describe NbaStatsCli do
  it "has a real player named kyrie irving" do
    expect(NbaStatsCli::PlayerScraper.new.find_player_url("Kyrie Irving")).not_to be nil
  end
  it "has a partial player named kyrie" do
    expect(NbaStatsCli::PlayerScraper.new.find_player_url("Kyrie")).not_to be nil
  end
  it "K has a default player named kobe " do
    expect(NbaStatsCli::PlayerScraper.new.find_player_url("K")).not_to be nil
  end
  it "Empty string is nil" do
    expect(NbaStatsCli::PlayerScraper.new.find_player_url(" ")).to be_nil
  end

end
