@javascript
Feature: Navigation
  Background:
    Given I am a signed in "user"

  Scenario: Active navigation category
    Given an existing category named "hello"
    And an existing category named "world"
    When I go on the "entries" page
    When I click on the "all_entries" navigation item
    Then active navigation item is "all_entries"
    When I click on the "starred" navigation item
    Then active navigation item is "starred"
    When I click on the "category_hello" navigation item
    Then active navigation item is "category_hello"
    When I click on the "category_world" navigation item
    Then active navigation item is "category_world"

  Scenario: Active navigation feed
    Given an existing category named "hello"
    And an existing feed named "world"
    When I go on the "entries" page
    Then I do not see "world"
    When I click on "#nav_category_hello .subnav-toggle" element
    Then I see "world"
    When I click on "world"
    Then active navigation item is "category_hello+feed_world"

  Scenario: Hide navigation badges if 0
    Given an existing category named "hello"
    And an existing category named "world"
    And an existing entry
    When I go on the "entries" page
    Then I do not see "#nav_category_hello .badge" element
    And I see "#nav_category_world .badge" element

  Scenario: Navigation live reload
    Given an existing category named "hello"
    And an existing entry
    And this existing entry "name" is "Example entry"
    When I go on the "entries" page
    Then I see "#nav_all_entries .badge" element
    And I see "#nav_category_hello .badge" element
    And I do not see "#nav_starred .badge" element
    When I click on "Example entry"
    Then I do not see "#nav_all_entries .badge" element
    And I do not see "#nav_category_hello .badge" element
    And I do not see "#nav_starred .badge" element
    When I click on ".entry-is_starred" element
    Then I do not see "#nav_all_entries .badge" element
    And I do not see "#nav_category_hello .badge" element
    And I see "#nav_starred .badge" element
    When I click on ".entry-is_read" element
    Then I see "#nav_all_entries .badge" element
    And I see "#nav_category_hello .badge" element
    And I see "#nav_starred .badge" element

  Scenario: Keyboard shortcuts modal
    When I go on the "entries" page
    And I press key "h"
    Then I see "Keyboard shortcuts" in modal
