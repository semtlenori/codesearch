#!/usr/bin/ruby

%w[benchmark pp rubygems].each { |x| require x }

require 'xmlsimple'
require 'optparse'
require File.dirname(__FILE__) + '/util'

def option_parser
	OptionParser.new do |opts|
		$verbose = false

		opts.banner = "Usage: regex-tester.rb [options] regexp trainset-dir"
		opts.on('-v', '--verbose', 'Output more information') do
			$verbose = true
		end

		opts.on('-h', '--help', 'Display this screen') do
			puts opts
			exit
		end

	end
end

if __FILE__ == $0
	op = option_parser
	options, argv = op.getopts, op.parse!
	pattern = Regexp.new(argv[0])
	dir = argv[1]

	messages = load_testset(dir)
	yes, no = messages['yes'].values, messages['no'].values
	yes_score = yes.find_all {|message| message.match(pattern)}.size
	no_score = no.find_all {|message| message.match(pattern)}.size
	score = (yes_score.to_f / yes.size) * (1.0 - no_score.to_f / no.size)
	puts "#{score} = (#{yes_score} / #{yes.size}) * (1.0 - #{no_score} / #{no.size})"
end
