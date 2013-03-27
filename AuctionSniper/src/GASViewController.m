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
{
    xmpp_ctx_t *xmpp_ctx;
    xmpp_conn_t *xmpp_conn;
}
//xmpp callbacks
//TODO this should be a protocol.
-(void) xmppDidConnect;

- (void)showJoiningStatus;
- (NSString*) auctionItemJid;
- (NSString*) jid;
- (NSString*) jidWithUser: (NSString*) aUser atHost: (NSString*) aHost;

@end

void HandleXmppConnectionStatusChanges(xmpp_conn_t *const conn,
                                       const xmpp_conn_event_t event,
                                       const int error,
                                       xmpp_stream_error_t *const stream_error,
                                       void *const userdata) {
    NSLog(@"whoohoo, the connection did something!");

    if (XMPP_CONN_CONNECT == event) {
        GASViewController *controller = (__bridge GASViewController*) userdata;
        [controller xmppDidConnect];
    } else {
        NSLog(@"A different event happened: %d", event);
    }
}



@implementation GASViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //set up the stream and set ourselves as the delegate.
    xmpp_initialize();
    xmpp_log_t *log = xmpp_get_default_logger(XMPP_LEVEL_DEBUG);
    assert(log);
    
    xmpp_ctx = xmpp_ctx_new(NULL, log);
    assert(xmpp_ctx);
    
    xmpp_conn = xmpp_conn_new(xmpp_ctx);
    assert(xmpp_conn);
    xmpp_conn_set_jid(xmpp_conn, [[self jid] cStringUsingEncoding: [NSString defaultCStringEncoding]]);
    xmpp_conn_set_pass(xmpp_conn, [AUCTION_PASSWORD cStringUsingEncoding: [NSString defaultCStringEncoding]]);
    
    assert(0 == xmpp_connect_client(xmpp_conn, NULL, 0, HandleXmppConnectionStatusChanges, (__bridge void*) self));
    
    xmpp_run(xmpp_ctx);

    [self showJoiningStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) disconnectFromServer
{
    if (! xmpp_ctx) return;
    
    xmpp_disconnect(xmpp_conn);
    xmpp_conn_release(xmpp_conn);
    xmpp_conn = NULL;
    
    xmpp_ctx_free(xmpp_ctx);
    xmpp_ctx = NULL;
    
    xmpp_shutdown();
}

#pragma mark -
#pragma mark XMPP Notifications

-(void) xmppDidConnect
{
    NSLog(@"XMPP Connected!");
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
    return [self jidWithUser: user atHost: AUCTION_HOST];
}

- (NSString*) jid
{
    return [self jidWithUser: AUCTION_USER atHost: AUCTION_HOST];
}

- (NSString*) jidWithUser: (NSString*) aUser atHost: (NSString*) aHost
{
    return [NSString stringWithFormat: @"%@@%@", aUser, aHost];
}

@end
