Given (/^I am on "([^"]*)"$/) do |path|
	visit path
end

Then (/^I should see "([^"]*)" in the selector "([^"]*)"$/) do |text, selector|
	page.body.should have_selector(selector, text)
end

Given (/^I select "([^"]*)" from "([^"]*)"$/) do |value, field|
	select(value, :from => field) 
end

When (/^I click "([^"]*)"$/) do |submit|
	click_on submit
end

Given (/^I am on "([^"]*)" with query "([^"]*)"$/) do |path, query|
	visit path + query
end