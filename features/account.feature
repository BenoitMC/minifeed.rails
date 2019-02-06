@javascript
Feature: Users
  Background:
    Given I am a signed in "user"

  Scenario: Update my password
    When I click on "Settings"
    And I click on "Manage my account"
    And I fill in "user_password" with "password"
    And I click on "Save"
    Then I see ".alert-success" element
    And I am signed in
