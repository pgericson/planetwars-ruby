require 'spec_helper'
describe PlanetWars do
  it "should not bomb out on the first turn" do
    File.open(File.join(File.dirname(__FILE__), "testrun"), "r") do |file|
      pw = PlanetWars.new(file)
      pw.play(Strategies.setup)
    end
  end
end
