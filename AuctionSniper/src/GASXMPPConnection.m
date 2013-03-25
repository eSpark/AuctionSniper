//
//  GASXMPPConnection.m
//  AuctionSniper
//
//  Created by John Richardson on 3/25/13.
//  Copyright (c) 2013 eSpark Learning. All rights reserved.
//

#import "GASXMPPConnection.h"

@implementation GASXMPPConnection

- (id) initWithJid:(NSString *)aJid andPassword:(NSString *)aPassword atHost:(NSString *)aHost {\
    if (self = [super init]) {
        _xmpp_jid = aJid;
        _xmpp_host = aHost;
        _xmpp_password = aPassword;
    }
    
    return self;
}

+(GASXMPPConnection *)connectionForJid:(NSString *)aJid andPassword:(NSString *)aPassword atHost:(NSString *)aHost {
    return [[GASXMPPConnection alloc] initWithJid:aJid andPassword:aPassword atHost:aHost];
}

@end
