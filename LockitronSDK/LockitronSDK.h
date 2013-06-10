//
//  Lockitron.h
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/9/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "LTLock.h"

typedef NS_ENUM(NSInteger, LockitronSDKLockState) {
    LockitronSDKNotConfigured,
    LockitronSDKLockOpen,
    LockitronSDKLockClosed
};

@interface LockitronSDK : NSObject

+ (void)startWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret;
+ (void)handleOpenURL:(NSURL *)url;

@end
