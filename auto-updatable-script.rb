#!/usr/bin/ruby
# require 'pry'
require 'digest'
require 'net/http'

class ScriptUpdater
  attr_reader :local_script_content, :local_script_digest, :remote_script_content, :remote_script_digest

  def initialize(remote_script_url)
    @local_script_content = File.read(__FILE__)
    @local_script_digest = Digest::SHA256.hexdigest(@local_script_content)
    @remote_script_content = Net::HTTP.get(URI(remote_script_url)) rescue @local_script_content
    @remote_script_digest = Digest::SHA256.hexdigest(@remote_script_content)
  end

  # returns a boolean indicating wether the script was updated or not
  def call
    return false unless new_version_available?
    puts "script needs update"
    File.open(__FILE__, 'w') do |file|
      file.puts remote_script_content
    end
    puts "updated :o)"
    true
  rescue
    puts "rescued!!"
    false
  end

  def new_version_available?
    remote_script_digest != local_script_digest 
  end
end

remote_script_url = 'https://raw.githubusercontent.com/ariera/auto-updatable-script/master/auto-updatable-script.rb'
if ScriptUpdater.new(remote_script_url).call
  puts "Script updated. Execution halted, please run the script again"
  exit
end

## Your code goes down here
puts "the script didn't an update so it will continue its execution as normal"