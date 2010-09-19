require 'logger'

module Logging
  def self.setup(options = {})
    debug = options[:debug] || ENV['BOT_DEBUG'] == "true"
    output = options[:output] || (debug ? "debug.log" : STDERR)
    level = options[:level] || (debug ? Logger::DEBUG : Logger::UNKNOWN)

    @@logger = Logger.new(output)
    @@logger.level = level
  end

  def logger
    @@logger
  end
end

