//
//  Lockitron.h
//  LockitronSDKExample
//
//  Created by Sebastien THIEBAUD on 6/10/13.
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

#import "LockitronSDK.h"
#import "LTLock.h"
#import "LTOAuthenticator.h"
#import "LTUser.h"
#import "LTKey.h"
#import "NSDictionary+URLEncoding.h"
