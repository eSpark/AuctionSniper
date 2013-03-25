//
//  GASViewController.h
//  AuctionSniper
//
//  Created by John Richardson on 3/21/13.
//  Copyright (c) 2013 eSpark Learning. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "strophe.h"
#import "GASXMPPConnection.h"

#define AUCTION_ID_FORMAT @"auction-item-%@@%@/%@" //item_id, xmpp_host, resource
#define AUCTION_HOST @"localhost"
#define AUCTION_RESOURCE @"Auction"

#define ITEM_ID @"54321"

#define AUCTION_PASSWORD @"sniper"
#define AUCTION_USER @"sniper"

@interface GASViewController : UIViewController
    @property (nonatomic, retain) GASXMPPConnection *xmpp_connection;
@end
