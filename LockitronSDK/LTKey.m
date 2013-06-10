//
//  LTKey.m
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/10/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "LTKey.h"

@implementation LTKey

- (NSString *)description
{
    NSString *role = @"";
    
    switch (_role) {
        case LockitronSDKUserAdmin:
            role = @"an admin";
            break;
        case LockitronSDKUserGuest:
            role = @"a guest";
            break;
    }
    
    return [NSString stringWithFormat:@"[LTKey] It's %@ %@valid and %@visible key for %@.", role, (_isValid) ? @"" : @"not ", (_isVisible) ? @"" : @"not ", _user];
}

@end
