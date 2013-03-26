Feature: Bidding on a single item
    As a bidder in an auction
    I would like to bid on items in order to win the auction.

    Background: 
        Given the auction is selling item "54321"

    Scenario: Joining the auction
        When I launch the app
        And I join the auction
        Then the auction has received a join request
        When the auction closes
        Then the sniper has lost the auction
