require 'test_helper'

#
# Testing reminders and other notifications. The amount and level of reminders
# is determined by the "pushiness" of a project.
#
# (I still need to determine what these do.)
#

class RemindersIntegrationTest < ActionDispatch::IntegrationTest

	describe "No reminders" do 
		it "should not send reminders at all"
	end

	describe "Moderate reminders" do 
		it "should send occasional reminders"
	end

	describe "Aggressive reminders" do
		it "should send lots of frequent reminders"
	end

end
