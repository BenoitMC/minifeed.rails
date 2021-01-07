@javascript
Feature: Keyboard shortcuts
  Background:
    Given I am a signed in "user"

  Scenario: Keyboard shortcuts modal
    When I go on the "entries" page
    And I press key "h"
    Then I see "Keyboard shortcuts" in modal
    And I press key "q"
    Then I do not see "#modal" element

  Scenario: Left/Right arrow navigation
    Given an existing entry
    And this existing entry "name" is "i am the third entry"
    And an existing entry
    And this existing entry "name" is "i am the second entry"
    And an existing entry
    And this existing entry "name" is "i am the first entry"
    When I go on the "entries" page
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
    When I go on the "entries" page
    When I press key "right"
    Then I see "i am the first entry" in modal

  Scenario: Left arrow shortcut on entries list opens last entry
    Given an existing entry
    And this existing entry "name" is "i am the second entry"
    And an existing entry
    And this existing entry "name" is "i am the first entry"
    When I go on the "entries" page
    When I press key "left"
    Then I see "i am the second entry" in modal

  Scenario: Set entry as read/unread
    Given an existing entry
    And this existing entry "name" is "Example entry"
    When I go on the "entries" page
    And I click on "Example entry"
    Then I see ".entry-is_read .fa-check-square" element
    And I do not see ".entry-is_read .fa-square" element
    When I press key "r"
    Then I see ".entry-is_read .fa-square" element
    And I do not see ".entry-is_read .fa-check-square" element
    When I press key "r"
    Then I see ".entry-is_read .fa-check-square" element
    And I do not see ".entry-is_read .fa-square" element

  Scenario: Set entry as starred/unstarred
    Given an existing entry
    And this existing entry "name" is "Example entry"
    When I go on the "entries" page
    And I click on "Example entry"
    Then I see ".entry-is_starred .far.fa-star" element
    And I do not see ".entry-is_starred .fas.fa-star" element
    When I press key "s"
    Then I see ".entry-is_starred .fas.fa-star" element
    And I do not see ".entry-is_starred .far.fa-star" element
    When I press key "s"
    Then I see ".entry-is_starred .far.fa-star" element
    And I do not see ".entry-is_starred .fas.fa-star" element

  Scenario: Open entry url in new tab
    Given an existing entry
    And this existing entry "name" is "Example entry"
    And this existing entry "url" is "/tests.html"
    When I go on the "entries" page
    And I click on "Example entry"
    And I press key "o"
    Then I see "Hello World" in a new tab

  Scenario: Open entry url in modal
    Given an existing entry
    And this existing entry "name" is "Example entry"
    And this existing entry "url" is "/tests.html"
    When I go on the "entries" page
    And I click on "Example entry"
    And I press key "m"
    Then I see "iframe" element
    Then I see "#modal" element

  Scenario: Reader mode in modal
    Given an existing entry
    And this existing entry "name" is "Example entry"
    And this existing entry "url" is "/tests.html"
    When I go on the "entries" page
    And I click on "Example entry"
    And I press key "p"
    Then I see "iframe" element
    Then I see "#modal" element
