//
//  GASAuctionSniper.h
//  AuctionSniper
//
//  Created by John Richardson on 3/29/13.
//  Copyright (c) 2013 eSpark Learning. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GASAuctionMessageListener.h"
#import "GASAuctionListener.h"

@interface GASAuctionSniper : NSObject<GASAuctionMessageListener>

@property (weak) id<GASAuctionListener> auctionListener;

- (id) initWithListener: (id<GASAuctionListener>) listener;

@end
