@javascript
Feature: Navigation
  Background:
    Given I am a signed in user

  Scenario: Active navigation items
    Given an existing category named "hello"
    And an existing category named "world"
    When I go on the entries page

    When I click on the "all_entries" navigation item
    Then active navigation item is "all_entries"

    When I click on the "starred" navigation item
    Then active navigation item is "starred"

    When I click on the "category_hello" navigation item
    Then active navigation item is "category_hello"

    When I click on the "category_world" navigation item
    Then active navigation item is "category_world"

  Scenario: Hide navigation badges if 0
    Given an existing category named "hello"
    And an existing category named "world"
    And an existing entry

    When I go on the entries page

    Then I do not see "#nav_category_hello .badge" element
    And I see "#nav_category_world .badge" element
