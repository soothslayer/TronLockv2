//
//  LTViewController.m
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/9/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "LTViewController.h"
#import "LTLockCell.h"
#import "SVProgressHUD.h"

#import "Lockitron.h"

@interface LTViewController () <UITableViewDataSource, UITableViewDelegate, LockitronSDKDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LTViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
        
    [LockitronSDK startWithClientID:@"" clientSecret:@"" delegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [SVProgressHUD showWithStatus:@"Please wait..."];
}

#pragma mark -
#pragma mark Lockitron delegate

- (void)lockitronIsReady
{
    [SVProgressHUD dismiss];
    [_tableView reloadData];
}

- (void)lockitronChangedLockState:(LTLock *)lock to:(LockitronSDKLockState)state
{
    int index = [[LockitronSDK locksList] indexOfObject:lock];
    
    LTLockCell *cell = (LTLockCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    if (state == LockitronSDKLockOpen)
    {
        [cell setUnlockAnimated:YES];
    }
    else if (state == LockitronSDKLockClosed)
    {
        [cell setLockAnimated:YES];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)lockitronDeniedAccess:(LTLock *)lock errorMessage:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"You don't have access to %@", lock.name] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

#pragma mark -
#pragma mark UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [LockitronSDK locksList].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LockCell";
    
    LTLockCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[LTLockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setDelegate:self];
    }
    
    LTLock *lock = (LTLock *)[[LockitronSDK locksList] objectAtIndex:indexPath.row];
    cell.name.text = lock.name;
    
    NSLog(@"%@: %@", lock.name, lock.keys);

    if (lock.state == LockitronSDKLockOpen)
    {
        [cell setUnlockAnimated:NO];
    }
    else if (lock.state == LockitronSDKLockClosed)
    {
        [cell setLockAnimated:NO];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

#pragma mark UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    LTLock *lock = (LTLock *)[[LockitronSDK locksList] objectAtIndex:indexPath.row];
    
    if (lock.state == LockitronSDKLockOpen)
    {
        [lock lock];
    }
    else
    {
        [lock unlock];
    }
}

@end
