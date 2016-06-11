Given (/^I am on "([^"]*)"$/) do |path|
	visit path
end

Then (/^I should see "([^"]*)"$/) do |text|
	page.body.should match(text)
end