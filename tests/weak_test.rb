require 'test/unit'
require 'test/unit/ui/console/testrunner'
require File.dirname(__FILE__) + '/../src/oneword'
require File.dirname(__FILE__) + '/../src/twoword'

class WeakClassifierTest < Test::Unit::TestCase
	def test_one_word_classifier
		# test for classifier can determine whether a log message is for bugfix or not
		yes = [
			'fix a bug',
			'fix an error',
			'fix a failure',
		]

		no = [
			'add a feature',
			'refactor the function',
			'add comments'
		]

		result = one_word_classifier(yes, no)

		assert_equal 'fix', result

		# test for classifier can determine whether a log message is for new feature or not
		yes = [
			'add a feature',
			'add new feature',
			'add a support'
		]

		no = [
			'fix a bug',
			'fix an error',
			'fix a failure',
			'refactor the function',
			'add comments'
		]

		result = one_word_classifier(yes, no)
		assert_equal 'add', result

		result = one_word_classifiers(yes, no)
		assert_equal 'add', result[0][0]
		assert_equal 'feature', result[1][0]
	end

	def test_two_word_classifier
		# test for classifier can determine whether a log message is for bugfix or not
		yes = [
			'fix a bug',
			'fix an error',
			'fix a failure',
		]

		no = [
			'add a feature',
			'refactor the function',
			'add comments'
		]

		result = two_word_classifiers(yes, no)

		assert_equal [nil, 'fix'], result[0][0]
		assert_equal ['fix', 'a'], result[1][0]

		# test for classifier can determine whether a log message is for new feature or not
		yes = [
			'add a feature',
			'add new feature',
			'add a support'
		]

		no = [
			'fix a bug',
			'fix an error',
			'fix a failure',
			'refactor the function',
			'add comments'
		]

		result = two_word_classifiers(yes, no)
		assert_equal [nil, 'add'], result[0][0]
		assert_equal ['add', 'a'], result[1][0]
	end
end
