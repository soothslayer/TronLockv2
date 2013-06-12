//
//  Lockitron.h
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/9/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "Lockitron.h"

@class LTLock;

@protocol LockitronSDKDelegate <NSObject>

@required
- (void)lockitronIsReady;

@optional
- (void)lockitronChangedLockState:(LTLock *)lock to:(LockitronSDKLockState)state;
- (void)lockitronDeniedAccess:(LTLock *)lock errorMessage:(NSString *)error;

@end

@interface LockitronSDK : NSObject

+ (void)startWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret delegate:(id<LockitronSDKDelegate>)delegate;
+ (void)handleOpenURL:(NSURL *)url;
+ (NSArray *)locksList;
//+ (LTUser *)userAuthenticated;

- (void)unlockDoor:(LTLock *)lock;
- (void)lockDoor:(LTLock *)lock;

@end
