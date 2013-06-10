//
//  Lockitron.m
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/9/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "LockitronSDK.h"
#import "LTOAuthenticator.h"
#import "LTRequestAPI.h"

@interface LockitronSDK () <LTOAuthenticatorDelegate>

@property (strong) LTOAuthenticator *authenticator;

@end

@implementation LockitronSDK
{
}

static LockitronSDK *_instance = nil;

+ (void)startWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret
{
    if (_instance == nil)
    {
        LTOAuthenticator *authenticator = [[LTOAuthenticator alloc] init];
        authenticator.clientID = clientID;
        authenticator.clientSecret = clientSecret;
        
        _instance = [[LockitronSDK alloc] init];
        _instance.authenticator = authenticator;
        authenticator.delegate = _instance;
    }
    
    [_instance.authenticator startAuthentication];
}

+ (void)handleOpenURL:(NSURL *)url
{
    NSArray *pathComponents = [[url absoluteString] componentsSeparatedByString:@"?code="];
    [_instance.authenticator authenticationCodeReceived:pathComponents[1]];
}

- (void)authenticationIsDone
{
    NSLog(@"Authentication is done.");
}

@end
