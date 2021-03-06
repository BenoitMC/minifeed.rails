@javascript
Feature: Entries
  Background:
    Given I am a signed in "user"

  Scenario: Filter entries by category
    Given an existing category named "hello"
    And an existing entry
    And this existing entry "name" is "hello entry"

    And an existing category named "world"
    And an existing entry
    And this existing entry "name" is "world entry"

    When I go on the "entries" page
    And I click on the "category_hello" navigation item
    Then I see "hello entry"
    And I do not see "world entry"

    When I go on the "entries" page
    And I click on the "category_world" navigation item
    Then I see "world entry"
    And I do not see "hello entry"

  Scenario: Filter entries by starred
    Given an existing entry
    And this existing entry "name" is "i am a starred entry"
    And this existing entry is starred
    And an existing entry
    And this existing entry "name" is "i am an other entry"

    When I go on the "entries" page
    When I click on the "starred" navigation item
    Then I see "i am a starred entry"
    And I do not see "i am an other entry"

  Scenario: Entries search
    Given an existing entry
    And this existing entry "name" is "ruby"
    And an existing entry
    And this existing entry "name" is "rails"
    When I go on the "entries" page
    Then I see "ruby"
    And I see "rails"
    When I search "ruby"
    Then I see "ruby"
    And I do not see "rails"

  Scenario: Read entry in modal
    Given an existing entry
    And this existing entry "name" is "i am an entry"
    And this existing entry "body" is "i am an entry body"
    When I go on the "entries" page
    And I click on "i am an entry"
    Then I see "i am an entry" in modal
    Then I see "i am an entry body" in modal

  Scenario: Open entry url in new tab
    Given an existing entry
    And this existing entry "name" is "Example entry"
    And this existing entry "url" is "/tests.html"
    When I go on the "entries" page
    And I click on "Example entry"
    And I click on ".entry-external_link" element
    Then I see "Hello World" in a new tab

  Scenario: Open entry url in modal
    Given an existing entry
    And this existing entry "name" is "Example entry"
    And this existing entry "url" is "/tests.html"
    When I go on the "entries" page
    And I click on "Example entry"
    And I click on ".entry-internal_link" element
    Then I see "iframe" element
    Then I see "#modal" element

  Scenario: Reader mode in modal
    Given an existing entry
    And this existing entry "name" is "Example entry"
    And this existing entry "url" is "/tests.html"
    When I go on the "entries" page
    And I click on "Example entry"
    And I click on ".entry-reader_link" element
    Then I see "iframe" element
    Then I see "#modal" element

  Scenario: Open entry body links in new page
    Given an existing entry
    And this existing entry "name" is "Example entry"
    And this existing entry "body" is "<a href='/tests.html'>entry body link</a>"
    When I go on the "entries" page
    And I click on "Example entry"
    And I click on "entry body link"
    Then I see "Hello World" in a new tab

  Scenario: Set entry as read/unread
    Given an existing entry
    And this existing entry "name" is "Example entry"
    When I go on the "entries" page
    And I click on "Example entry"
    Then I see ".entry-is_read .fa-check-square" element
    And I do not see ".entry-is_read .fa-square" element
    When I click on ".entry-is_read" element
    Then I see ".entry-is_read .fa-square" element
    And I do not see ".entry-is_read .fa-check-square" element
    When I click on ".entry-is_read" element
    Then I see ".entry-is_read .fa-check-square" element
    And I do not see ".entry-is_read .fa-square" element

  Scenario: Set entry as starred/unstarred
    Given an existing entry
    And this existing entry "name" is "Example entry"
    When I go on the "entries" page
    And I click on "Example entry"
    Then I see ".entry-is_starred .far.fa-star" element
    And I do not see ".entry-is_starred .fas.fa-star" element
    When I click on ".entry-is_starred" element
    Then I see ".entry-is_starred .fas.fa-star" element
    And I do not see ".entry-is_starred .far.fa-star" element
    When I click on ".entry-is_starred" element
    Then I see ".entry-is_starred .far.fa-star" element
    And I do not see ".entry-is_starred .fas.fa-star" element

  Scenario: Refresh read/unread on list
    Given an existing entry
    And this existing entry "name" is "Example entry"
    When I go on the "entries" page
    Then I do not see ".entry.is_read" element
    When I click on "Example entry"
    And I press key "q"
    Then I see ".entry.is_read" element

  Scenario: Mark all as read global
    Given an existing entry
    When I go on the "entries" page
    Then I see ".entry" element
    When I click on "Mark all as read"
    Then I do not see ".entry" element

  Scenario: Mark all as read in category
    Given an existing category named "hello"
    And an existing entry
    And an existing category named "world"
    And an existing entry
    When I go on the "entries" page
    And I click on the "category_hello" navigation item
    Then I see "#nav_category_hello.active" element
    And I see ".entry" element
    When I click on "Mark all as read"
    Then I do not see ".entry" element
    When I click on the "category_world" navigation item
    Then I see "#nav_category_world.active" element
    And I see ".entry" element

  Scenario: Entries pagination
    Given 25 existing entries
    When I go on the "entries" page
    Then I see 10 times ".entry" element
    When I click on "Load more entries"
    Then I see 20 times ".entry" element
    When I click on "Load more entries"
    Then I see 25 times ".entry" element
    And I do not see "Load more entries"
