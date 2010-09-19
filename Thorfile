$LOAD_PATH.unshift("lib")
require "open3"
require "date"
require "fileutils"
require "core_ext"
require "bot"
require "fight"
require "fight_aggregator"

class Default < Thor
  include Thor::Actions
  include FileUtils::Verbose

  desc "clean", "Remove all game files."
  def clean
    rm(Dir["visualizer/games/*.game"]) rescue nil
  end

  desc "fight [OPPONENT]", "Pit your bot against opponent on a random map"
  method_options :show => false, :map => :string, :turns => 500, :verbose => false
  def fight(opponent = Bot::DEFAULT_OPPONENT)
    @f = Fight.new(options.merge({:opponent => opponent, :shell => self.shell}))
    @f.fight
    @f.show_game if options.show?
  end

  desc "fightall [OPPONENT]", "Fight on all maps"
  method_options :turns => 500, :maps => "maps/*"
  def fightall(opponent = Bot::DEFAULT_OPPONENT)
    agg = FightAggregator.new(options.merge({:opponent => opponent, :shell => self.shell}))
    begin
      Dir.glob(options.maps).sort.each do |map| 
        agg.fight(map) 
      end
    rescue Interrupt
      say
    end
    agg.summary
  end

  desc "zip", "Bundle the bot as a zip file for submission"
  def zip
    rm("bot.zip") if File.exists?("bot.zip")
    cd("src")
    `zip -r ../bot.zip *.rb`
  end

  desc "upload", "Upload bot.zip to the contest website."
  def upload
    invoke :zip
    require "mechanize"

    agent = Mechanize.new

    say "Opening login page"
    login_page = agent.get("http://ai-contest.com/login.php")
    login = login_page.form("login_form")

    credentials = YAML.load_file(File.join(File.dirname(__FILE__), ".login"))
    login.username = credentials["username"]
    login.password = credentials["password"]

    say "Logging in as #{credentials["username"]}"
    result = agent.submit(login)
    unless result.links.first.text.strip.start_with? "My Profile"
      say "Login failed!", :red
      return
    end

    upload = agent.get("submit.php")
    upload_form = upload.forms.first
    upload_form.file_uploads.first.file_name = "bot.zip"

    unless yes? "Are you sure you wish to upload?"
      say "Upload aborted.", :red
      return
    end

    say "Uploading bot"
    resp agent.submit(upload.forms.first)

    if resp.body =~ /Success!/
      say "Submission successful.", :green
    else
      say "Submission failed!", :red
    end
  end

  desc "spec", "Run a rudimentary test against MyBot"
  def spec
    system "rspec spec/ --color"
  end
end
