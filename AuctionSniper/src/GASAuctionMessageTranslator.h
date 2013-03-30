//
//  GASAuctionMessageTranslator.h
//  AuctionSniper
//
//  Created by John Richardson on 3/29/13.
//  Copyright (c) 2013 eSpark Learning. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GASAuctionMessageListener.h"

@interface GASAuctionMessageTranslator : NSObject
 
@property (weak)  id<GASAuctionMessageListener> auctionMessageListener;

- (id) initWithListener: (id<GASAuctionMessageListener>) listener;
- (void) receivedMessage: (NSString*) message;
@end
