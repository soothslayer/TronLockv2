//
//  LTKey.h
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/10/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "LockitronSDK.h"

@class LTLock;
@class LTUser;

@interface LTKey : NSObject

@property (strong) NSString *id;
@property (strong) LTUser *user;
@property (assign) LockitronSDKUserRole role;
@property (strong) NSDate *validFrom;
@property (strong) NSDate *validTo;
@property (assign) BOOL isValid;
@property (assign) BOOL isVisible;

@end
