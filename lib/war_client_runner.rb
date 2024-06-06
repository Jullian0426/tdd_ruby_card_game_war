# frozen_string_literal: true

require_relative 'client'

client = Client.new(3336)
loop do
  output = ''
  output = client.capture_output until output != ''
  if output.include?(':')
    print output
    client.provide_input(gets.chomp)
  else
    puts output
  end
end
