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
        case -1:
            state = @"not configured";
            break;
        case 0:
            state = @"Locked";
            break;
        case 1:
            state = @"Unlocked";
            break;
    }
    
    return [NSString stringWithFormat:@"%@ is %@.", _name, state];
}

- (void)unlock
{
    [_delegate sendCommand:@"unlock" toLock:self];
}

- (void)lock
{
    [_delegate sendCommand:@"lock" toLock:self];
}
- (void)changeSleepIntervalTo:(NSString*)sleepInterval {
    [_delegate changeSleepInterval:sleepInterval toLock:self];
}
@end
