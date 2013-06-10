//
//  LTOAuthenticator.h
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/9/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

@protocol LTOAuthenticatorDelegate <NSObject>

@required
- (void)authenticationIsDone;

@end

@interface LTOAuthenticator : NSObject

@property (strong) NSString *clientID;
@property (strong) NSString *clientSecret;
@property (strong) NSString *access_token;
@property (weak) id<LTOAuthenticatorDelegate> delegate;

- (void)startAuthentication;
- (void)authenticationCodeReceived:(NSString *)code;

@end
