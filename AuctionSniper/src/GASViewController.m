//
//  GASViewController.m
//  AuctionSniper
//
//  Created by John Richardson on 3/21/13.
//  Copyright (c) 2013 eSpark Learning. All rights reserved.
//

#import "GASViewController.h"
#import "strophe.h"

#pragma mark -
#pragma mark private method declarations

@interface GASViewController ()

- (void)showJoiningStatus;
- (NSString*) auctionItemJid;
@end

@implementation GASViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //set up the stream and set ourselves as the delegate.
        xmpp_initialize();
    }
    
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //initiate the connection to the server
    //[self showJoiningStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark helper methods

- (void)showJoiningStatus
{
    [self.statusLabel setText: @"Joining..."];
    [self.statusLabel setHidden: NO];
}

- (NSString*) auctionItemJid
{
    NSString * user = [NSString stringWithFormat: AUCTION_ID_FORMAT, @"54321"];
    return [NSString stringWithFormat: @"%@@%@", user, AUCTION_HOST];
}

@end
