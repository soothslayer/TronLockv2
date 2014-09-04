//
//  HMLockitronAccount.h
//  TronLockv2
//
//  Created by Hanlon Miller on 8/14/14.
//  Copyright (c) 2014 Hanlon Miller Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LTLock;
@class LTUser;

@protocol HMLockitronAccountDelegate <NSObject>

@required
- (void)lockitronIsReady;

@optional
- (void)lockitronChangedLockState:(LTLock *)lock to:(NSInteger)state;
- (void)lockitronDeniedAccess:(LTLock *)lock errorMessage:(NSString *)error;

@end

@interface HMLockitronAccount : NSObject

+ (void)startWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret URIcallback:(NSString *)URIcallback delegate:(id<HMLockitronAccountDelegate>)delegate;
+ (void)handleOpenURL:(NSURL *)url;
+ (NSArray *)locksList;
+ (LTUser *)userAuthenticated;
+ (void)refreshLocks;
- (void)sendCommand:(NSString *)command toLock:(LTLock *)lock;
- (void)changeSleepInterval:(NSString *)command toLock:(LTLock *)lock;
+ (NSArray *)loadLocksfromUserDefaults;
- (void)saveLocks;
@end
