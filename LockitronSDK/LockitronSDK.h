//
//  Lockitron.h
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/9/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

typedef NS_ENUM(NSInteger, LockitronSDKLockState) {
    LockitronSDKLockNotConfigured = -1,
    LockitronSDKLockOpen,
    LockitronSDKLockClosed
};

typedef NS_ENUM(NSInteger, LockitronSDKUserRole) {
    LockitronSDKUserGuest,
    LockitronSDKUserAdmin
};

@interface LockitronSDK : NSObject

+ (void)startWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret;
+ (void)handleOpenURL:(NSURL *)url;

+ (void)locksGranted:(void (^)(NSArray *locks))locks;

@end
