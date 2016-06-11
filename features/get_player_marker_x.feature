Feature: Viewer visits the choose X page
	As a viewer
	I want to see the choose X page
	In order to choose which player I want to be X

	Scenario: Get player for X directly
	Given I am on "/playermarker" with query "?player_one=Human&player_two=Human"
	And I select "Player one" from "choice_for_x"
	And I click "submit"
	Then I should see "Player one is X and player two is O." in the selector "h1"
	And I should see "Here is the current board:" in the selector "h2"
