require 'digest'
require 'net/http'

class ScriptUpdater
  REMOTE_SCRIPT_URL = 'https://raw.githubusercontent.com/ariera/auto-updatable-script/master/auto-updatable-script.rb'
  def initialize
    local_script_content = File.read(__FILE__)
    local_script_digest = Digest::SHA256.hexdigest(local_script_content)
    remote_script_content = Net::HTTP.get(URI(REMOTE_SCRIPT_URL))
    remote_script_digest = Digest::SHA256.hexdigest(remote_script_content)

    if remote_script_digest != local_script_digest
      puts "script needs update"
      File.open(__FILE__, 'w') do |file|
        file.puts remote_script_content
      end
    else
      puts "no update needed"
    end
  end
end

ScriptUpdater.new
puts "done :D"
