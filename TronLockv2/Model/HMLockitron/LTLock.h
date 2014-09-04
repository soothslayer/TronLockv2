//
//  LTLock.h
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/9/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "HMLockitronStatic.h"

@interface LTLock : NSObject

@property (strong) NSString *id;
@property (strong) NSNumber *latitude;
@property (strong) NSNumber *longitude;
@property (strong) NSString *name;
@property (assign) NSInteger state;
//@property (assign) NSUInteger state;
@property (strong) NSArray *keys;
//v2 only properties
@property (assign) int avr_update_progress;
@property (assign) NSInteger ble_update_progress;
@property (strong) NSString *button_type;
@property (strong) NSString *handedness;
@property (strong) NSDate *next_wake;
@property (strong) NSArray *pending_activity;
@property (strong) NSString *serial_number;
@property (assign) int sleep_period;
@property (assign) BOOL sms;
@property (strong) NSString *time_zone;
@property (strong) NSDate *updated_at;

@property (weak) id delegate;

- (void)unlock;
- (void)lock;
- (void)changeSleepIntervalTo:(NSString*)sleepInterval;
@end
