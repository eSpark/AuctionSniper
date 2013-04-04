//
//  GASAuctionMessageTranslator.m
//  AuctionSniper
//
//  Created by John Richardson on 3/29/13.
//  Copyright (c) 2013 eSpark Learning. All rights reserved.
//

#import "GASAuctionMessageTranslator.h"

@interface GASAuctionMessageTranslator()
-(NSDictionary*) unpack: (NSString*) message;
@end

@implementation GASAuctionMessageTranslator

- (id) initWithListener: (id<GASAuctionMessageListener>) listener
{
    if (self = [super init]) {
        self.auctionMessageListener = listener;
    }
    
    return self;
}

- (void) receivedMessage:(NSString *)message
{
    NSDictionary *auctionEvent = [self unpack: message];
    NSString *eventType = [auctionEvent valueForKey: @"Event"];
    
    if ([eventType isEqualToString: @"CLOSE"]) {
        [self.auctionMessageListener auctionClosed];
    } else {
        [self.auctionMessageListener auctionPriceChangedTo: [[auctionEvent valueForKey: @"CurrentPrice"] intValue]
                                             withIncrement: [[auctionEvent valueForKey: @"Increment"] intValue]
                                                highBidder: [auctionEvent valueForKey: @"Bidder"]];
    }
}

-(NSDictionary*) unpack:(NSString *)message
{
    NSArray *messageParts = [message componentsSeparatedByString: @";"];
    NSAssert([messageParts count] > 0, @"Invalid Message %@, no event!", message);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity: [messageParts count]];

    for(NSString *messagePart in messageParts) {
        //the string ends with ; so we'll get an extra chunk that is empty.
        if ([messagePart length] == 0) continue;
        
        NSArray *keyAndValue = [messagePart componentsSeparatedByString: @":"];
        NSAssert([keyAndValue count] == 2, @"Invalid message component %@", messagePart);
        [dictionary setValue: [[keyAndValue objectAtIndex: 1]
                               stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]
                      forKey: [[keyAndValue objectAtIndex: 0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
    }
         
    return dictionary;
}

@end
