Feature: Viewer visits the Entry Page
	As a viewer
	I want to see the entry page of my app
	In order to start the app
	  
	Scenario: View entry page
		Given I am on "/"
	    Then I should see "Hello, please choose your player types. You can choose a human player, or an AI player which is either simple or sequential." in the selector "h2"

	Scenario: Get player types
		Given I am on "/"
		And I select "Human" from "player_one"
		And I select "Human" from "player_two"
		And I click "submit"
		Then I should see "Player one is Human and player two is Human." in the selector "h2"
		And I should see "Would you like player one or two to be X?" in the selector "h4"