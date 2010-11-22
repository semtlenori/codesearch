#!/usr/bin/ruby

%w[benchmark pp rubygems].each { |x| require x }

require 'xmlsimple'
require 'optparse'
require File.dirname(__FILE__) + '/util'

def one_word_classifiers(yes, no)
	best_score = 0
	best_word = nil
	words = {}

	yes_words = yes.map {|message| get_words message}.flatten.uniq
	yes_words.each do |word|
		yes_score = yes.find_all {|message| get_words(message).include? word}.size
		no_score = no.find_all {|message| get_words(message).include? word}.size
		score = (yes_score.to_f / yes.size) * (1.0 - no_score.to_f / no.size)
		words[word] = score
	end

	# sort by score
	words.sort {|x, y| x[1] <=> y[1]}.reverse
end

def one_word_classifier(yes, no)
	one_word_classifiers(yes, no)[0][0]
end

def option_parser
	OptionParser.new do |opts|
		$verbose = false

		opts.banner = "Usage: oneword.rb [options] trainset-dir"
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
	dir = argv[0]

	messages = load_testset(dir)
	one_word_classifiers(messages['yes'].values, messages['no'].values).each do |item|
		puts "/\\b#{item[0]}\\b/i\t#{item[1]}"
	end
end
