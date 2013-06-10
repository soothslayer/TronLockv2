//
//  LTUser.m
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/9/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "LTUser.h"

@implementation LTUser

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@ user)", _fullName, (_isActivated) ? @"activated" : @"inactivated"];
}

@end
