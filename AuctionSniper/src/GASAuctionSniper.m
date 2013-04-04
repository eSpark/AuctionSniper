//
//  GASAuctionSniper.m
//  AuctionSniper
//
//  Created by John Richardson on 3/29/13.
//  Copyright (c) 2013 eSpark Learning. All rights reserved.
//

#import "GASAuctionSniper.h"

@implementation GASAuctionSniper

- (id) initWithListener:(id<GASAuctionListener>)listener
{
    if (self = [super init]) {
        self.auctionListener = listener;
    }
    
    return self;
}

- (void) auctionClosed
{
    [self.auctionListener sniperLost];
}

- (void) auctionPriceChangedTo:(int)newPrice withIncrement:(int)increment highBidder:(NSString *)highBidder
{
    
}
@end
