$LOAD_PATH.unshift(File.join(File.dirname(File.dirname(__FILE__)), "src"))
require 'logging'
Logging.setup(:debug => true, :output => STDERR)

require 'planet_wars'
require 'strategies'
