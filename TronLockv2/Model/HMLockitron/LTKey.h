//
//  LTKey.h
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/10/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "HMLockitronStatic.h"



@class LTLock;
@class LTUser;

@interface LTKey : NSObject

@property (strong) NSString *id;
@property (strong) LTUser *user;
@property (assign) NSUInteger role;
@property (strong) NSDate *validFrom;
@property (strong) NSDate *validTo;
@property (assign) BOOL isValid;
@property (assign) BOOL isVisible;

//v2 properties
@property (strong) NSString *access_key;
@property (strong) NSDate *expiration_date;
@property (strong) NSString *sms_pin;
@property (strong) NSDate *start_date;

@end
