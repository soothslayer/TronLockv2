//
//  LTLock.m
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/9/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "LTLock.h"

@implementation LTLock

- (NSString *)description
{
    NSString *state = @"";
    
    switch (_state) {
        case LockitronSDKLockNotConfigured:
            state = @"not configured";
            break;
        case LockitronSDKLockClosed:
            state = @"closed";
            break;
        case LockitronSDKLockOpen:
            state = @"open";
            break;
    }
    
    return [NSString stringWithFormat:@"[LTLock] %@ is %@. Keys' list: %@", _name, state, _keys];
}

@end
