Feature: Bidding on a single item
  As a bidder in an auction
  I would like to bid on items in order to win the auction.

  Background: 
    Given the auction is selling item "54321"

  #chapter 11
  Scenario: Sniper joins the auction and loses
    When I launch the app
    And I join the auction
    And the auction has received a join request from the sniper
    When the auction closes
    Then the sniper has lost the auction

  #chapter 12
  Scenario: Sniper makes a higher bid but loses
    When I launch the app
    And I join the auction
    And the auction has received a join request from the sniper
    And the auction reports a high bidder "other bidder" at a price of "1000" with an increment of "98"
    Then the sniper should be bidding
    And the auction should receive a bid from the sniper of "1098"
    When the auction closes
    Then the sniper has lost the auction
