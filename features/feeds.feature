@javascript
Feature: Feeds
  Background:
    Given I am a signed in "user"
    And an existing category named "My Category"

  Scenario: Create a feed
    When I click on "Settings"
    And I click on "Manage feeds"
    And I click on "Create"
    And I fill in "url" with "https://www.ruby-lang.org/en/"
    And I click on "Search"
    And I click on "Ruby News"
    And I click on "Save"
    Then I see ".has-error" element
    When I select "My Category"
    And I click on "Save"
    Then I see "Feed successfully created"
    And I see "Ruby News"

  Scenario: Update a feed
    Given an existing feed named "My feed"
    When I click on "Settings"
    And I click on "Manage feeds"
    Then I see "My feed"
    When I click on "Update"
    And I fill in "feed_name" with ""
    And I click on "Save"
    Then I see ".has-error" element
    When I fill in "feed_name" with "New feed name"
    And I click on "Save"
    Then I see "Feed successfully update"
    And I see "New feed name"

  Scenario: Delete a feed
    Given an existing feed named "My feed"
    When I click on "Settings"
    And I click on "Manage feeds"
    Then I see "My feed"
    When I click on "Delete"
    Then I see "Feed successfully deleted"
    Then I do not see "My feed"

  Scenario: Search a feed
    Given an existing feed named "ruby"
    And an existing feed named "rails"
    When I click on "Settings"
    And I click on "Manage feeds"
    Then I see "ruby"
    And I see "rails"
    When I search "ruby"
    Then I see "ruby"
    And I do not see "rails"
