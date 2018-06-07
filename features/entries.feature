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
    And this existing entry "name" is "Example entry"
    And this existing entry "url" is "http://example.org/"
    When I go on the entries page
    And I click on "Example entry"
    And I click on ".entry-external_link" element
    Then I see "Example Domain" in a new tab

  Scenario: Open entry url in modal
    Given an existing entry
    And this existing entry "name" is "Example entry"
    And this existing entry "url" is "http://example.org/"
    When I go on the entries page
    And I click on "Example entry"
    And I click on ".entry-internal_link" element
    Then I see "iframe" element
    Then I see "#modal" element

  Scenario: Reader mode in modal
    Given an existing entry
    And this existing entry "name" is "Example entry"
    And this existing entry "url" is "http://example.org/"
    When I go on the entries page
    And I click on "Example entry"
    And I click on ".entry-reader_link" element
    Then I see "iframe" element
    Then I see "#modal" element

  Scenario: Left/Right arrow navigation
    Given an existing entry
    And this existing entry "name" is "i am the third entry"
    And an existing entry
    And this existing entry "name" is "i am the second entry"
    And an existing entry
    And this existing entry "name" is "i am the first entry"
    When I go on the entries page
    And I click on "i am the first entry"
    Then I see "i am the first entry" in modal
    When I press key "right"
    Then I see "i am the second entry" in modal
    When I press key "right"
    Then I see "i am the third entry" in modal
    When I press key "right"
    Then I see "i am the third entry" in modal
    When I press key "left"
    Then I see "i am the second entry" in modal
    When I press key "left"
    Then I see "i am the first entry" in modal
    When I press key "left"
    Then I see "i am the first entry" in modal

  Scenario: Right arrow shortcut on entries list open first entry
    Given an existing entry
    And this existing entry "name" is "i am the second entry"
    And an existing entry
    And this existing entry "name" is "i am the first entry"
    When I go on the entries page
    When I press key "right"
    Then I see "i am the first entry" in modal

  Scenario: Left arrow shortcut on entries list opens last entry
    Given an existing entry
    And this existing entry "name" is "i am the second entry"
    And an existing entry
    And this existing entry "name" is "i am the first entry"
    When I go on the entries page
    When I press key "left"
    Then I see "i am the second entry" in modal

  Scenario: Open entry body links in new page
    Given an existing entry
    And this existing entry "name" is "Example entry"
    And this existing entry "body" is "<a href='http://example.org/'>entry body link</a>"
    When I go on the entries page
    And I click on "Example entry"
    And I click on "entry body link"
    Then I see "Example Domain" in a new tab

  Scenario: Set entry as read/unread from icon
    Given an existing entry
    And this existing entry "name" is "Example entry"
    When I go on the entries page
    And I click on "Example entry"
    Then I see ".entry-is_read .fa-check-square" element
    And I do not see ".entry-is_read .fa-square" element
    When I click on ".entry-is_read" element
    Then I see ".entry-is_read .fa-square" element
    And I do not see ".entry-is_read .fa-check-square" element
    When I click on ".entry-is_read" element
    Then I see ".entry-is_read .fa-check-square" element
    And I do not see ".entry-is_read .fa-square" element

  Scenario: Set entry as starred/unstarred from icon
    Given an existing entry
    And this existing entry "name" is "Example entry"
    When I go on the entries page
    And I click on "Example entry"
    Then I see ".entry-is_starred .far.fa-star" element
    And I do not see ".entry-is_starred .fas.fa-star" element
    When I click on ".entry-is_starred" element
    Then I see ".entry-is_starred .fas.fa-star" element
    And I do not see ".entry-is_starred .far.fa-star" element
    When I click on ".entry-is_starred" element
    Then I see ".entry-is_starred .far.fa-star" element
    And I do not see ".entry-is_starred .fas.fa-star" element

  Scenario: Set entry as read/unread from shortcuts
    Given an existing entry
    And this existing entry "name" is "Example entry"
    When I go on the entries page
    And I click on "Example entry"
    Then I see ".entry-is_read .fa-check-square" element
    And I do not see ".entry-is_read .fa-square" element
    When I press key "r"
    Then I see ".entry-is_read .fa-square" element
    And I do not see ".entry-is_read .fa-check-square" element
    When I press key "r"
    Then I see ".entry-is_read .fa-check-square" element
    And I do not see ".entry-is_read .fa-square" element

  Scenario: Set entry as starred/unstarred from shortcuts
    Given an existing entry
    And this existing entry "name" is "Example entry"
    When I go on the entries page
    And I click on "Example entry"
    Then I see ".entry-is_starred .far.fa-star" element
    And I do not see ".entry-is_starred .fas.fa-star" element
    When I press key "s"
    Then I see ".entry-is_starred .fas.fa-star" element
    And I do not see ".entry-is_starred .far.fa-star" element
    When I press key "s"
    Then I see ".entry-is_starred .far.fa-star" element
    And I do not see ".entry-is_starred .fas.fa-star" element

  Scenario: Open entry url in new tab from shortcuts
    Given an existing entry
    And this existing entry "name" is "Example entry"
    And this existing entry "url" is "http://example.org/"
    When I go on the entries page
    And I click on "Example entry"
    And I press key "o"
    Then I see "Example Domain" in a new tab

  Scenario: Open entry url in modal from shortcuts
    Given an existing entry
    And this existing entry "name" is "Example entry"
    And this existing entry "url" is "http://example.org/"
    When I go on the entries page
    And I click on "Example entry"
    And I press key "m"
    Then I see "iframe" element
    Then I see "#modal" element

  Scenario: Reader mode in modal from shortcuts
    Given an existing entry
    And this existing entry "name" is "Example entry"
    And this existing entry "url" is "http://example.org/"
    When I go on the entries page
    And I click on "Example entry"
    And I press key "p"
    Then I see "iframe" element
    Then I see "#modal" element

  Scenario: Refresh read/unread on list
    Given an existing entry
    And this existing entry "name" is "Example entry"
    When I go on the entries page
    Then I do not see ".entry.is_read" element
    When I click on "Example entry"
    And I click on "#modal-close" element
    Then I see ".entry.is_read" element

  Scenario: Mark all as read global
    Given an existing entry
    When I go on the entries page
    Then I see ".entry" element
    When I click on "Mark all as read"
    Then I do not see ".entry" element

  Scenario: Mark all as read in category
    Given an existing category named "hello"
    And an existing entry
    And an existing category named "world"
    And an existing entry
    When I go on the entries page
    And I click on the "category_hello" navigation item
    Then I see ".entry" element
    When I click on "Mark all as read"
    Then I do not see ".entry" element
    When I click on the "category_world" navigation item
    Then I see ".entry" element

  Scenario: Entries pagination
    Given 250 existing entries
    When I go on the entries page
    Then I see 100 times ".entry" element
    When I click on "Load more entries"
    Then I see 200 times ".entry" element
    When I click on "Load more entries"
    Then I see 250 times ".entry" element
    And I do not see "Load more entries"
