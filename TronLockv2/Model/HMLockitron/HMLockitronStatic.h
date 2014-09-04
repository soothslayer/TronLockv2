//
//  HMLockitronStatic.h
//  TronLockv2
//
//  Created by Hanlon Miller on 8/15/14.
//  Copyright (c) 2014 Hanlon Miller Inc. All rights reserved.
//

#ifndef TronLockv2_HMLockitronStatic_h
#define TronLockv2_HMLockitronStatic_h
#import "HMLockitronAccount.h"
#import "LTKey.h"
#import "LTLock.h"
#import "LTUser.h"
#import "Controller/LTLockCell.h"
#import "Controller/HMLockCell.h"

//Couldn't get this to work so I have to take it out for now
typedef NS_ENUM(NSInteger, LockitronSDKLockState) {
    LockitronSDKLockNotConfigured = -1,
    LockitronSDKLockOpen,
    LockitronSDKLockClosed
};

typedef NS_ENUM(NSInteger, LockitronSDKUserRole) {
    LockitronSDKUserGuest,
    LockitronSDKUserAdmin
};


static const NSString *lockitronURL = @"https://api.lockitron.com/v1/";
static const NSString *lockitronBaseURL = @"https://api.lockitron.com/";
static const NSString *lockitronCommandURL = @"https://api.lockitron.com/v1/locks";
static const NSString *suiteName = @"group.hanlonmiller";


#endif
