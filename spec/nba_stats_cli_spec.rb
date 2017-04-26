require "spec_helper"

RSpec.describe NbaStatsCli do
  it "has a version number" do
    expect(NbaStatsCli::VERSION).not_to be nil
  end

end
