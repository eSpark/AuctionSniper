//
//  GASViewController.m
//  AuctionSniper
//
//  Created by John Richardson on 3/21/13.
//  Copyright (c) 2013 eSpark Learning. All rights reserved.
//

#import "GASViewController.h"


@interface GASViewController ()

@end

@implementation GASViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.xmppStream = [[XMPPStream alloc] init];
        
        XMPPJID *jid = [XMPPJID jidWithUser: AUCTION_USER domain: AUCTION_HOST resource: AUCTION_RESOURCE];
        self.xmppStream.myJID = jid;
        [self.xmppStream addDelegate: self delegateQueue: dispatch_get_main_queue()];
    }
    
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *error = nil;

    NSAssert([self.xmppStream connect: &error],
             @"Error connecting to XMPP Server: %@", error.localizedDescription);
    [self.statusLabel setText: @"Joining..."];
    [self.statusLabel setHidden: NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark XMPPStreamDelegate methods

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSError *error = nil;
    NSAssert([sender authenticateWithPassword:AUCTION_PASSWORD error:&error],
             @"Error authenticating to XMPP: %@", error.localizedDescription);
}

- (void)xmppStream:(XMPPStream *)sender didNotConnect:(NSError *)error
{
    NSLog(@"Failed to connect, %@", error);
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSString *auctionItemUser = [NSString stringWithFormat: AUCTION_ID_FORMAT, @"54321"];
    XMPPJID *itemJid = [XMPPJID jidWithUser: auctionItemUser domain: AUCTION_HOST resource: AUCTION_RESOURCE];

    //mark ourselves as present so we can receive messages
    XMPPPresence *presence = [XMPPPresence presence];
    [sender sendElement: presence];
    
//    //subscribe to auction so we can receive messages back
//    presence = [XMPPPresence presenceWithType: @"subscription" to: itemJid];
//    [sender sendElement: presence];
    
    //send join message
    XMPPMessage *joinMessage = [XMPPMessage messageWithType:@"chat" to: itemJid];
    NSXMLNode *body = [NSXMLNode elementWithName: @"body" stringValue: @""];
    [joinMessage addChild: body];

    [sender sendElement: joinMessage];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"Failed to authenticate, %@", error);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"Received Message %@", message);
    [self.statusLabel setText: @"Lost"];
}

@end
