@javascript
Feature: Categories
  Background:
    Given I am a signed in user

  Scenario: Create a category
    When I click on "Settings"
    And I click on "Manage categories"
    And I click on "Create"
    And I fill in "category_name" with "Hello"
    And I click on "Save"
    Then I see "Category successfully created"
    And I see "#nav_category_hello" element

  Scenario: Update a category
    Given an existing category named "hello"
    When I click on "Settings"
    And I click on "Manage categories"
    And I click on "Update"
    And I fill in "category_name" with "world"
    And I click on "Save"
    Then I see "Category successfully update"
    And I see "#nav_category_world" element
    And I do not see "#nav_category_hello" element

  Scenario: Delete a category
    Given an existing category named "hello"
    When I click on "Settings"
    And I click on "Manage categories"
    And I click on "Delete"
    Then I see "Category successfully delete"
    And I do not see "#nav_category_hello" element

  Scenario: Reorder categories
    Given an existing category named "hello"
    Given an existing category named "world"
    When I click on "Settings"
    And I click on "Manage categories"
    Then I see "hello" before "world"
    And I click on "Reorder"
    And I reorder elements
    And I click on "Save"
    Then I see "Categories successfully reordered"
    Then I see "world" before "hello"
