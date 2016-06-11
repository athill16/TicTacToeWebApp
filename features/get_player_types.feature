Feature: Viewer visits the Entry Page
	As a viewer
	I want to see the entry page of my app
	In order to start the app
	  
	Scenario: View entry page
		Given I am on "/"
	    Then I should see "Hello, please choose your player types. You can choose a human player, or an AI player which is either "simple" or "sequential.""