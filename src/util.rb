#!/usr/bin/ruby

%w[benchmark pp rubygems].each { |x| require x }

require 'xmlsimple'
require 'optparse'

def get_words(message)
	# get downcased words as a list from a message
	message.split.map {|item| item.scan(Regexp.new('[#\w]*')).reject {|x| x == ''}.map {|x| x.downcase}}.flatten
end

def load_testset(dir)
	messages = {'yes' => {}, 'no' => {}}
	['yes', 'no'].each do |category|
		cur_dir = File.join(dir, category)
		files = Dir.entries(cur_dir).find_all {|file| File.extname(file) == '.xml'}
		files.each do |file|
			XmlSimple.xml_in(File.join(cur_dir, file), {'KeyAttr' => 'revision'})['logentry'].each do |rev, data|
				messages[category][rev] = data['msg'][0]
			end
		end
	end
	messages
end

def make_pairs (items)
	b = nil
	items.map {|new| a, b = b, new}
end

