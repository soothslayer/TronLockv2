//
//  LTViewController.m
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/9/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "LTViewController.h"
#import "Lockitron.h"

@interface LTViewController () <LockitronSDKDelegate>

- (IBAction)unlockTheDoor:(id)sender;
- (IBAction)lockTheDoor:(id)sender;

@end

@implementation LTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [LockitronSDK startWithClientID:@"3e20f758745841523ebf76621bf6c1a5ca7e919c6fca1688c34db61f9d68cd8e" clientSecret:@"2fb6b28550ca17787a1bd920cfe25e693316d084ee590d7aeb64324f12835783" delegate:self];
}

- (void)lockitronIsReady
{
    NSLog(@"Lockitron is ready to work!");
    NSLog(@"%@", [LockitronSDK locksList]);    
}

- (void)lockitronChangedLockState:(LTLock *)lock to:(LockitronSDKLockState)state
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lock/Unlock" message:[NSString stringWithFormat:@"%@ is now %@", lock.name, (lock.state == LockitronSDKLockClosed) ? @"closed" : @"open"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)lockitronDeniedAccess:(LTLock *)lock errorMessage:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"You don't have access to %@", lock.name] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (IBAction)lockTheDoor:(id)sender
{
    LTLock *lock = (LTLock *)[[LockitronSDK locksList] objectAtIndex:0];
    [lock lock];
}

- (IBAction)unlockTheDoor:(id)sender
{
    LTLock *lock = (LTLock *)[[LockitronSDK locksList] objectAtIndex:0];
    [lock unlock];
}

@end
