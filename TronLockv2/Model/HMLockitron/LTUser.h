//
//  LTUser.h
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/9/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface LTUser : NSObject

@property (strong) NSString *id;
@property (assign) BOOL isActivated;
@property (strong) NSString *email;
@property (strong) NSString *firstName;
@property (strong) NSString *lastName;
@property (strong) NSString *fullName;
@property (strong) NSString *bestName;
@property (strong) NSString *phoneNumber;
@property (strong) NSString *humanPhoneNumber;

//v2 properties
@property (strong) NSURL *avatar_url;
@property (assign) BOOL changing_email;
@property (assign) BOOL changing_phone;
@property (assign) BOOL facebook;
@end
