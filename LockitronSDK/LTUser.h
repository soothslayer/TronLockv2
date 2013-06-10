//
//  LTUser.h
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/9/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

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

@end
