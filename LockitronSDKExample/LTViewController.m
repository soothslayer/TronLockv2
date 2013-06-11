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
        
    [LockitronSDK startWithClientID:@"3e20f758745841523ebf76621bf6c1a5ca7e919c6fca1688c34db61f9d68cd8e" clientSecret:@"2fb6b28550ca17787a1bd920cfe25e693316d084ee590d7aeb64324f12835783" delegate:self];
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
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
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
    
    if (lock.state == LockitronSDKLockOpen)
    {
        [cell setUnlock];
    }
    else if (lock.state == LockitronSDKLockClosed)
    {
        [cell setLock];
    }
    else
    {
    
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
