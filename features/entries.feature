@javascript
Feature: Navigation
  Background:
    Given I am a signed in user

  Scenario: Filter entries by category
    Given an existing category named "hello"
    And an existing entry in this category named "hello entry"
    And an existing category named "world"
    And an existing entry in this category named "world entry"

    When I go on the entries page
    And I click on the "category_hello" navigation item
    Then I see "hello entry"
    And I do not see "world entry"

    When I go on the entries page
    And I click on the "category_world" navigation item
    Then I see "world entry"
    And I do not see "hello entry"

  Scenario: Filter entries by starred
    Given an existing starred entry named "i am a starred entry"
    And an existing entry named "i am an other entry"

    When I go on the entries page
    When I click on the "starred" navigation item
    Then I see "i am a starred entry"
    And I do not see "i am an other entry"
