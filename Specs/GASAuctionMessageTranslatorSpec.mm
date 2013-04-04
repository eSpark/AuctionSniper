#import "SpecHelper.h"

#import "GASAuctionMessageTranslator.h"
#import "GASAuctionMessageListener.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(GASAuctionMessageTranslatorSpec)


describe(@"GASAuctionMessageTranslator", ^{
    __block GASAuctionMessageTranslator *subject;
    
    beforeEach(^{
        subject = [[[GASAuctionMessageTranslator alloc] init] retain];
        subject.auctionMessageListener = nice_fake_for(@protocol(GASAuctionMessageListener));
    });
    
    describe(@"-receivedMessage:", ^{
        it(@"sends auctionClosed when a close is received", ^{
            [subject receivedMessage: @"SOLVersion: 1.1; Event: CLOSE;"];
            expect(subject.auctionMessageListener).to(have_received(@selector(auctionClosed)));
        });
        
        it (@"sends auctionPriceChanged:highBidder when a price change is received", ^{
            [subject receivedMessage: @"SOLVersion: 1.1; Event: PRICE; CurrentPrice: 192; Increment: 7; Bidder: Someone else;"];
            expect(subject.auctionMessageListener).to(have_received(@selector(auctionPriceChangedTo:withIncrement:highBidder:)).with(192, 7, @"Someone else"));
        });
    });
});

SPEC_END

