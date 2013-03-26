//
//  GASViewController.h
//  AuctionSniper
//
//  Created by John Richardson on 3/21/13.
//  Copyright (c) 2013 eSpark Learning. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMPP.h"

#define AUCTION_ID_FORMAT @"auction-item-%@"
#define AUCTION_HOST @"localhost"
#define AUCTION_RESOURCE @"Auction"

#define ITEM_ID @"54321"

#define AUCTION_PASSWORD @"sniper"
#define AUCTION_USER @"sniper"

@interface GASViewController : UIViewController

@property (nonatomic, retain) XMPPStream *xmppStream;
@property (nonatomic, retain) IBOutlet UILabel *statusLabel;

#pragma mark -
#pragma mark XMPPStreamDelegate methods

- (void)xmppStreamDidConnect:(XMPPStream *)sender;
- (void)xmppStream:(XMPPStream *)sender didNotConnect:(NSError *)error;
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender;
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error;
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message;

@end
