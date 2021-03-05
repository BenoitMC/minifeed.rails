@javascript
Feature: Users
  Background:
    Given I am a signed in "admin"

  Scenario: Create user
    When I click on "#user-nav" element
    And I click on "Settings"
    And I click on "Manage users"
    Then I see 1 times ".user" element
    And I click on "Create"
    And I click on "Save"
    Then I see ".has-error" element
    And I fill in "user_name" with "Alice"
    And I fill in "user_email" with "alice@example.org"
    And I fill in "user_password" with "password"
    And I select "Yes" from "Is admin"
    And I click on "Save"
    Then I see ".toast-success" element
    And I see 2 times ".user" element

  Scenario: Update user
    When I click on "#user-nav" element
    And I click on "Settings"
    And I click on "Manage users"
    Then I do not see "new@example.org"
    And I click on "Update"
    And I fill in "user_email" with ""
    And I click on "Save"
    Then I see ".has-error" element
    When I fill in "user_email" with "new@example.org"
    When I fill in "user_password" with "new_password"
    And I click on "Save"
    Then I see ".toast-success" element
    And I am signed in
    And I see "new@example.org"
