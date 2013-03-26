require 'xmpp4r'
require 'xmpp4r/roster'

module AuctionSniper
  class FakeAuctionServer
    attr_reader :join_requests

    def initialize(itemid)
      @join_requests = 0
      @itemid = itemid
    end

    def start_selling_item
      connect_to_server
      add_callbacks
    end

    def stop_selling_item
      if @message
        stop_message = Jabber::Message.new.set_type(:chat)
        stop_message.to = @message.from
        stop_message.from = jid
        stop_message.body = 'lost'
        @client.send(stop_message)
      end

      @client.close
    end

  private
    def jid
      Jabber::JID.new("auction-item-#{@itemid}@localhost/auction")
    end
    def connect_to_server
      @client = Jabber::Client.new(jid)
      @client.connect
      @client.auth('auction')
      @client.send(Jabber::Presence.new.set_type(:chat))

      @roster = Jabber::Roster::Helper.new(@client)
    end

    def add_callbacks
      @roster.add_subscription_request_callback do |request, presence|
        puts "received subscription request"
        @roster.accept_subscription(presence.from)
      end

      @client.add_message_callback do |message|
        puts "Recieved Message"
        @message = message
        @join_requests += 1
      end
    end
  end
end
