//
//  GASAuctionMessageListener.h
//  AuctionSniper
//
//  Created by John Richardson on 3/29/13.
//  Copyright (c) 2013 eSpark Learning. All rights reserved.
//

#import <Foundation/Foundation.h>

//This protocol represents the various auction events that can be received
//by an auction participant.
@protocol GASAuctionMessageListener <NSObject>

- (void) auctionClosed;
- (void) auctionPriceChangedTo: (int) newPrice withIncrement: (int) increment highBidder: (NSString*) highBidder;
@end
