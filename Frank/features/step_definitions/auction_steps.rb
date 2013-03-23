Given(/^the auction is selling item "(.*?)"$/) do |item_id|
    server = AuctionSniper::FakeAuctionServer.new(item_id.to_i)
    server.start_selling_item
end

When(/^I join the auction$/) do
    check_element_exists "view:'UILabel' marked:'Joining...'"
end

Then(/^the auction should have received a join requeset$/) do
    expect(server.join_requests.length).to eq(1)
end

When(/^the auction closes$/) do
    server.stop_selling_item
end

Then(/^the sniper has lost the auction$/) do
    check_element_exists "view:'UILabel' marked:'Lost'"
end
