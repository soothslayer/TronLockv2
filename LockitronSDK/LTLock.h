//
//  LTLock.h
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/9/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "LockitronSDK.h"

@interface LTLock : NSObject

@property (strong) NSString *id;
@property (strong) NSNumber *latitude;
@property (strong) NSNumber *longitude;
@property (strong) NSString *name;
@property (assign) LockitronSDKLockState state;
@property (strong) NSArray *keys;

@end
