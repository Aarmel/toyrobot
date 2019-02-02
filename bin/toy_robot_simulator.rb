# !/usr/bin/env ruby
#
# See README.md
#
require 'timeout'
require './lib/robot/Robot'

line = ''
robot = Robot.new
puts 'Start'

begin
  while line != "quit\n"
    Timeout::timeout(20) do
      line = ARGF.readline
    end
    robot.process_command(line)
  end
rescue Timeout::Error
  puts 'Input timed out.'
end

puts 'Bye!'
