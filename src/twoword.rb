#!/usr/bin/ruby

%w[benchmark pp rubygems].each { |x| require x }

require 'xmlsimple'
require 'optparse'
require File.dirname(__FILE__) + '/util'

def two_word_classifiers(yes, no)
	best_score = 0
	best_word = nil
	word_pairs = {}

	yes_words = []
	yes.each {|message| yes_words += make_pairs(get_words(message))}
	yes_words.uniq!

	yes_words.each do |word_pair|
		yes_score = yes.find_all {|message| make_pairs(get_words(message)).include? word_pair}.size
		no_score = no.find_all {|message| make_pairs(get_words(message)).include? word_pair}.size
		score = (yes_score.to_f / yes.size) * (1.0 - no_score.to_f / no.size)
		word_pairs[word_pair] = score
	end

	# sort by score
	word_pairs.sort {|x, y| x[1] <=> y[1]}.reverse
end

def option_parser
	OptionParser.new do |opts|
		$verbose = false

		opts.banner = "Usage: twoword.rb [options] trainset-dir"
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

	two_word_classifiers(messages['yes'].values, messages['no'].values).each do |item|
		if item[0][0] == nil
			puts "/^[^\\w]*\\b#{item[0][1]}\\b/i\t#{item[1]}"
		elsif item[0][1] == nil
			puts "/\\b#{item[0][0]}\\b[^\\w]*$/i\t#{item[1]}"
		else
			puts "/\\b#{item[0][0]}\\b[^\\w]+\\b#{item[0][1]}\\b/i\t#{item[1]}"
		end
	end
end
