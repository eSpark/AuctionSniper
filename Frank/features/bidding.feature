Feature: Bidding on a single item
    As a bidder in an auction
    I would like to bid on items in order to win the auction.

    Background: 
        Given I launch the app

    Scenario: Joining the auction
        Given the auction is selling item "54321"
        When I join the auction
        Then the auction should have received a join requeset
        When the auction closes
        Then the sniper has lost the auction
