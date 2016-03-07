@javascript
Feature: Home page
  Scenario: Home page
    Given I am a signed in user
    When I go to the home page
    Then I see the home page
