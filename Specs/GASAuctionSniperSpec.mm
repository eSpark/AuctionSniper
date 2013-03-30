#import "SpecHelper.h"

#import "GASAuctionSniper.h"
#import "GASAuctionListener.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(GASAuctionMessageSniperSpec)


describe(@"GASAuctionMessageTranslator", ^{
    __block GASAuctionSniper *subject;
    
    beforeEach(^{
        subject = [[[GASAuctionSniper alloc] init] retain];
        subject.auctionListener = nice_fake_for(@protocol(GASAuctionListener));
    });
    
    describe(@"- auctionClosed", ^{
        it(@"sends -sniperLost to the sniperListener if it has lost", ^{
            [subject auctionClosed];
            expect(subject.auctionListener).to(have_received(@selector(sniperLost)));
        });
    });
});

SPEC_END

