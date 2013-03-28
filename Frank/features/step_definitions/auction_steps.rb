Given(/^the auction is selling item "(.*?)"$/) do |item_id|
  @server = AuctionSniper::FakeAuctionServer.new(item_id.to_i)
  @server.start_selling_item
end

When(/^I join the auction$/) do
  check_element_exists "view:'UILabel' marked:'Joining...'"
end

Then(/^the auction has received a join request from the sniper$/) do
  expect(@server.messages.length).to be > 0
  #TODO: assert message from sniper@localhost and is valid join request.
end

When(/^the auction closes$/) do
  @server.stop_selling_item
end

Then(/^the sniper has lost the auction$/) do
  wait_for_element_to_exist "view:'UILabel' marked:'Lost'"
end

When(/^the auction reports a high bidder "(.*?)" at a price of "(.*?)" with an increment of "(.*?)"$/) do |bidder, price, bid_increment|
  @server.report_price price: price.to_i, bid_increment: bid_increment.to_i, bidder: bidder
end

Then(/^the sniper should be bidding$/) do
  wait_for_element_to_exist "view:'UILabel' marked:'Bidding'"
end

Then(/^the auction should receive a bid from the sniper of "(.*?)"$/) do |bid|
  expect(@server.message.body).to eq("SOLVersion: 1.1; Command: BID; Price: #{bid};")
end
