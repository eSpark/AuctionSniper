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
- (void) xmppDidConnect;

- (void) showAuctionStatus: (NSString*) status;

- (NSString*) auctionItemJid;
- (NSString*) jid;
- (NSString*) jidForUser: (NSString*) aUser atHost: (NSString*) aHost;

@end

@interface GASViewController (SniperListener) <GASAuctionListener>

@end

//WIP TODO
//change controller to AuctionSniper in the userdata, and use the protocol.

//This handles received xmpp messages.
//for now, any message means we lost, and we ask to update the
//controller status to lost.
int HandleXmppMessage(xmpp_conn_t * const conn, xmpp_stanza_t * const stanza, void * const userdata) {
    char *buf = NULL;
    size_t buf_len = 0;
    xmpp_stanza_to_text(stanza, &buf, &buf_len);
    NSLog(@"received message: %s", buf);
    char* stanza_name = xmpp_stanza_get_name(stanza);
    if (0 == strncmp("message", stanza_name, sizeof("message"))) {
        char *body = xmpp_stanza_get_text(xmpp_stanza_get_child_by_name(stanza, "body"));
        
        GASAuctionMessageTranslator *messageTranslator = (__bridge GASAuctionMessageTranslator*) userdata;
        [messageTranslator receivedMessage: [NSString stringWithCString: body encoding: [NSString defaultCStringEncoding]]];
    }
    return 1;
}

//connection status change handler.
//registers handlers with connected connection, and tells the controller
//that we are connected.
void HandleXmppConnectionStatusChanges(xmpp_conn_t *const conn,
                                       const xmpp_conn_event_t event,
                                       const int error,
                                       xmpp_stream_error_t *const stream_error,
                                       void *const userdata) {
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
        xmpp_initialize();

        self.auctionSniper = [[GASAuctionSniper alloc] initWithListener: self];
        self.auctionMessageTranslator = [[GASAuctionMessageTranslator alloc] initWithListener: self.auctionSniper];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //connect xmpp.
    //TODO: move this to an XMPPConnection class or something.
    xmpp_ctx = xmpp_ctx_new(NULL, xmpp_get_default_logger(XMPP_LEVEL_DEBUG));
    assert(xmpp_ctx);
    
    xmpp_conn = xmpp_conn_new(xmpp_ctx);
    assert(xmpp_conn);
    xmpp_conn_set_jid(xmpp_conn, [[self jid] cStringUsingEncoding: [NSString defaultCStringEncoding]]);
    xmpp_conn_set_pass(xmpp_conn, [AUCTION_PASSWORD cStringUsingEncoding: [NSString defaultCStringEncoding]]);
    
    assert(0 == xmpp_connect_client(xmpp_conn, NULL, 0, HandleXmppConnectionStatusChanges, (__bridge void*) self));

    //start the xmpp event loop in another queue.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        xmpp_run(xmpp_ctx);
    });

    [self showAuctionStatus: @"Joining..."];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TODO: implement reconnect.
- (void) disconnectFromServer
{
    if (! xmpp_ctx) return;
    
    xmpp_stop(xmpp_ctx);
    
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
    
    //register the message handler
    xmpp_handler_add(xmpp_conn, HandleXmppMessage, NULL, NULL, NULL, (__bridge void*) self.auctionMessageTranslator);
    
    //set our presence so we are active and can receive messages.
    NSLog(@"becoming active...");
    xmpp_stanza_t *presenceStanza = xmpp_stanza_new(xmpp_ctx);
    xmpp_stanza_set_name(presenceStanza, "presence");
    xmpp_send(xmpp_conn, presenceStanza);
    xmpp_stanza_release(presenceStanza);
    NSLog(@"became active.");
    
    //subscribe
    const char *auctionItemJid = [[self auctionItemJid] cStringUsingEncoding: [NSString defaultCStringEncoding]];
    xmpp_stanza_t *subscription = xmpp_stanza_new(xmpp_ctx);
    xmpp_stanza_set_name(subscription, "presence");
    xmpp_stanza_set_type(subscription, "subscription");
    xmpp_stanza_set_attribute(subscription, "to", auctionItemJid);
    xmpp_send(xmpp_conn, subscription);
    xmpp_stanza_release(subscription);
    
    //join
    NSLog(@"sending join request...");
    xmpp_stanza_t *joinRequest = xmpp_stanza_new(xmpp_ctx);
    xmpp_stanza_set_name(joinRequest, "message");
    xmpp_stanza_set_type(joinRequest, "chat");
    xmpp_stanza_set_attribute(joinRequest, "to", auctionItemJid);

    xmpp_stanza_t *body = xmpp_stanza_new(xmpp_ctx);
    xmpp_stanza_set_name(body, "body");
    xmpp_stanza_t *text = xmpp_stanza_new(xmpp_ctx);
    xmpp_stanza_set_text(text, [AUCTION_JOIN_MESSAGE cStringUsingEncoding: [NSString defaultCStringEncoding]]);
    xmpp_stanza_add_child(body, text);
    xmpp_stanza_add_child(joinRequest, body);
    xmpp_send(xmpp_conn, joinRequest);
    xmpp_stanza_release(joinRequest);
    NSLog(@"sent join request.");
    
}

#pragma mark -
#pragma mark AuctionEventListener methods
- (void) sniperLost
{
    dispatch_async(dispatch_get_main_queue(), ^{[self showAuctionStatus: @"Lost"];});;
}


#pragma mark -
#pragma mark helper methods

- (void) showAuctionStatus: (NSString*) status
{
    [self.statusLabel setText: status];
    [self.statusLabel setHidden: NO];
}

- (NSString*) auctionItemJid
{
    NSString * user = [NSString stringWithFormat: AUCTION_ID_FORMAT, @"54321"];
    return [self jidForUser: user atHost: AUCTION_HOST];
}

- (NSString*) jid
{
    return [self jidForUser: AUCTION_USER atHost: AUCTION_HOST];
}

- (NSString*) jidForUser: (NSString*) aUser atHost: (NSString*) aHost
{
    return [NSString stringWithFormat: @"%@@%@", aUser, aHost];
}


@end
