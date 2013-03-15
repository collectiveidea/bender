Feature: A user can view the keg

  Scenario: Immediately after a keg has been tapped
    Given a beer tap
    And a keg on this beer tap with name "Better Beer"
    And I go to the root page
    And I follow "Better Beer"
    Then I should see "Better Beer" within ".page-header h1"
    And I should see "Leaderboard"
    And I should see "Stats"
    And I should see "Kegerator Temperatures"

  Scenario: After first pour
    Given a beer tap
    And a keg on this beer tap with name "Better Beer"
    And John pours a 6.2 oz Better Beer
    When I go to the root page
    And I follow "Better Beer"

    Then I should see /John +6\.2 +6\.2 +6\.2 +1/
    And I should see /Poured +6 oz/
    And I should see /Remaining +630 oz/
    And I should see /Pours +1/
    And I should see /Average pour volume +6\.2 oz/

    When Jane pours a 7.9 oz Better Beer
    And I refresh

    Then I should see /John +6\.2 +6\.2 +6\.2 +1/
    And I should see /Jane +7\.9 +7\.9 +7\.9 +1/
    And I should see /Poured +14 oz/
    And I should see /Remaining +622 oz/
    And I should see /Pours +2/
    And I should see /Average pour volume +7\.0 oz/
