//
//  GASXMPPConnection.h
//  AuctionSniper
//
//  Created by John Richardson on 3/25/13.
//  Copyright (c) 2013 eSpark Learning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "strophe.h"

@interface GASXMPPConnection : NSObject
{
    NSString *_xmpp_host;
    NSString *_xmpp_jid;
    NSString *_xmpp_password;
};

+(GASXMPPConnection*) connectionForJid: (NSString*) aJid andPassword: (NSString*) aPassword atHost: (NSString*) aHost;
-(id) initWithJid: (NSString*) aJid andPassword: (NSString*) aPassword atHost: (NSString*) aHost;

@end
