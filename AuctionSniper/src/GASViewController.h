//
//  GASViewController.h
//  AuctionSniper
//
//  Created by John Richardson on 3/21/13.
//  Copyright (c) 2013 eSpark Learning. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AUCTION_ID_FORMAT @"auction-item-%@"
#define AUCTION_HOST @"localhost"
#define AUCTION_RESOURCE @"Auction"

#define ITEM_ID @"54321"

#define AUCTION_PASSWORD @"sniper"
#define AUCTION_USER @"sniper"

@interface GASViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *statusLabel;

- (void) disconnectFromServer;

@end
