//
//  GASAuctionListener.h
//  AuctionSniper
//
//  Created by John Richardson on 3/29/13.
//  Copyright (c) 2013 eSpark Learning. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GASAuctionListener <NSObject>

@required

- (void) sniperLost;

@end
