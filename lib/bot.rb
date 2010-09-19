class Bot
  attr_reader :name, :command

  DEFAULT_BOT = "src/MyBot.rb"
  DEFAULT_OPPONENT = "bots/DualBot.jar"

  def initialize(file)
    @file = file
    @name = File.basename(@file)
    @command = self.commandify
  end

  protected
  def commandify
    if @file =~ /.jar/
      "java -jar #{@file}"
    elsif @file =~ /.rb/
      "ruby #{@file}"
    else
      raise "Unknown bot type."
    end
  end
end
