//
//  HMAuthenticator.h
//  TronLockv2
//
//  Created by Hanlon Miller on 8/14/14.
//  Copyright (c) 2014 Hanlon Miller Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HMAuthenticatorDelegate <NSObject>

@required
- (void)authenticationIsDone;

@end

@interface HMAuthenticator : NSObject

@property (strong) NSString *clientID;
@property (strong) NSString *clientSecret;
@property (strong) NSString *access_token;
@property (weak) id<HMAuthenticatorDelegate> delegate;

- (id)initWithURIcallback:(NSString *)URIcallback;
- (void)startAuthentication;
- (void)authenticationCodeReceived:(NSString *)code;

@end