require 'sinatra'
require 'sinatra/base'
require 'roolz'
require 'json'
require 'oj'


@rool_array = ['', 'blank', 'email', 'greater_than', 'less_than', 'equal', 'regex', 'include', 'subset']

def symbol_hashilate(my_hash = {})
	my_hash = my_hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
end

def bad_hack(string)
	if string == ''
		return Rool::Basic
	end
	# if string == 'all'
	# 	return Rool::All
	# end
	if string == 'blank'
		return Rool::Blank
	end
	if string == 'email'
		return Rool::Email
	end
	if string == 'greater_than'
		return Rool::GreaterThan
	end
	if string == 'include'
		return Rool::Include
	end
	if string == 'less_than'
		return Rool::LessThan
	end
	if string == 'equal'
		return Rool::Equal
	end
	if string == 'subset'
		return Rool::Subset
	end
	if string == 'regex'
		return Rool::Regex
	end
end

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
	@fullhash = Hash.new
	@rool_array = ['basic', 'all', 'blank', 'email', 'greater_than', 'less_than', 'equal']
	# @data = {foo: 12, bar: [1, 2, 3, 4, 5]}
	# @nested_rule = Rool::All.new(Rool::Equal.new(:foo, 10), Rool::Send.new(:bar, 30),Rool::All.new(Rool::Equal.new(:foo, 10), Rool::Send.new(:bar, 30)))
	# @nested_rule.process(@data)
	# @nested_rule_json = JSON.parse(@nested_rule.to_json)

	# @test_raw_json = JSON.pretty_generate(@nested_rule_json)

	# @test_type_of = @nested_rule.class.to_s.split('::')[1].strip

	# @test_display = display_rool(@nested_rule_json)

	erb :home
end

post '/add_to_hash' do
@rool_array = ['', 'blank', 'email', 'greater_than', 'less_than', 'equal', 'regex', 'include', 'subset']
	@key = params[:hashkey]
	@value = params[:hashvalue]
	# Address this first. Need to evaluate things passed in as arrays and hashes
	if @value.include? ','
		@value = @value.split(',').map(&:to_i)
	elsif @value.to_i.to_s == @value
		@value = @value.to_i
	end
	@old_hash = eval(params[:fullhash])
	@new_hash = @old_hash.merge!(@key => @value)
	@fullhash = symbol_hashilate(@new_hash)
	@key_array = @fullhash.keys

	erb :home
end

post '/run_rool' do
@rool_array = ['', 'blank', 'email', 'greater_than', 'less_than', 'equal', 'regex', 'include', 'subset']
	@fullhash = eval(params[:fullhash])
	puts "this is the parsed hash"
	p @fullhash
	@key_array = @fullhash.keys
	@rool = params[:rool]
	@operand = params[:operand]
	if @operand.to_i.to_s == @operand
		@operand = @operand.to_i
	end
	@hash_key = params[:hash_key]
	@rool_obj = bad_hack(@rool).new(@hash_key.to_sym, @operand)
	p @rool_obj
	@rool_obj.process(@fullhash)
	@against = Rool::Equal.new(@hash_key, 12)
	puts "did this change?"
	p @rool_obj
	@result = display_rool(JSON.parse(@rool_obj.to_json))

	erb :home
end




		
	