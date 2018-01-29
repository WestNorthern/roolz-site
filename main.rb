require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'roolz'
require 'json'

set :database, "sqlite3:main.sqlite3"


def display_rool(hash, iteration = 0)
  iteration += 1
  output = ""
  hash.each do |key, value|

    if value.is_a?(Hash)
      output += "<div class='entry' style='margin-left:#{iteration * 2}em'> <span style='font-size:#{250 - iteration*20}%'>#{key}: </span><br>"
      output += display_rool(value, iteration)
      output += "</div>"
    elsif value.is_a?(Array)
      output += "<div class='entry' style='margin-left:#{iteration * 2}em'> <span style='color: darkorchid'>#{key}: </span><br>"
      value.each do |value|
          if value.is_a?(String) then
              output += "<div style='margin-left:#{iteration * 2}em'>#{value} </div>"
          else
              output += display_rool(value,iteration-1)
          end
      end
      output += "</div>"

    else
        output += "<div class='entry' style='margin-left:#{iteration}em'> <span style='font-weight: bold'>#{key}: </span>#{value}</div>"
    end
  end
  return output
end

get '/' do
	@data = {foo: 12, bar: [1, 2, 3, 4, 5]}
	@thing = Rool::All.new(Rool::Equal.new(:foo, 10), Rool::Send.new(:bar, 30),Rool::All.new(Rool::Equal.new(:foo, 10), Rool::Send.new(:bar, 30)))
	@thing.process(@data)
	@testing = JSON.parse(@thing.to_json)

	@test = JSON.pretty_generate(@testing)

	@test_two = display_rool(@testing)

	# @test_three = display_rool(@test)
	puts @test
	erb :home
end
		
	