@javascript
Feature: Entries
  Background:
    Given I am a signed in user

  Scenario: Filter entries by category
    Given an existing category named "hello"
    And an existing entry
    And this existing entry "name" is "hello entry"

    And an existing category named "world"
    And an existing entry
    And this existing entry "name" is "world entry"

    When I go on the entries page
    And I click on the "category_hello" navigation item
    Then I see "hello entry"
    And I do not see "world entry"

    When I go on the entries page
    And I click on the "category_world" navigation item
    Then I see "world entry"
    And I do not see "hello entry"

  Scenario: Filter entries by starred
    Given an existing entry
    And this existing entry "name" is "i am a starred entry"
    And this existing entry is starred
    And an existing entry
    And this existing entry "name" is "i am an other entry"

    When I go on the entries page
    When I click on the "starred" navigation item
    Then I see "i am a starred entry"
    And I do not see "i am an other entry"

  Scenario: Read entry in modal
    Given an existing entry
    And this existing entry "name" is "i am an entry"
    And this existing entry "body" is "i am an entry body"
    When I go on the entries page
    And I click on "i am an entry"
    Then I see "i am an entry" in modal
    Then I see "i am an entry body" in modal

  Scenario: Open entry url in new tab
    Given an existing entry
    And this existing entry "name" is "Github entry"
    And this existing entry "url" is "https://github.com/"
    When I go on the entries page
    And I click on "Github entry"
    And I click on ".entry-external_link" element
    Then I see "Sign up for GitHub" in a new tab
