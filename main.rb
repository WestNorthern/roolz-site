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
      output += "<div class='entry' style='margin-left:#{iteration * 2}em'> <span style='font-size:#{250 - iteration*20}%'>#{key unless key == "^o"}: </span><br>"
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
    	if key == "^o"
    		output += "<hr>"
    		output += "<div class='entry' style='margin-left:#{iteration}em'> <span style='font-weight: bold; font-size: 2em'>#{value.split('::')[1].strip}</span></div>"
    		output += "<hr>"
    	else
      	output += "<div class='entry' style='margin-left:#{iteration}em'> <span style='font-weight: bold'>#{key}</span> &nbsp; &nbsp; &nbsp; #{value}</div>"
      end
    end
  end
  return output
end

get '/' do
	@data = {foo: 12, bar: [1, 2, 3, 4, 5]}
	@nested_rule = Rool::All.new(Rool::Equal.new(:foo, 10), Rool::Send.new(:bar, 30),Rool::All.new(Rool::Equal.new(:foo, 10), Rool::Send.new(:bar, 30)))
	@nested_rule.process(@data)
	@nested_rule_json = JSON.parse(@nested_rule.to_json)

	@test_raw_json = JSON.pretty_generate(@nested_rule_json)

	@test_type_of = @nested_rule.class.to_s.split('::')[1].strip

	@test_display = display_rool(@nested_rule_json)

	# @test_three = display_rool(@test)
	puts @test
	erb :home
end
		
	