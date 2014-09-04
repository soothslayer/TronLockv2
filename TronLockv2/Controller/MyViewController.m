//
//  MyViewController.m
//  TronLockv2
//
//  Created by Hanlon Miller on 8/14/14.
//  Copyright (c) 2014 Hanlon Miller Inc. All rights reserved.
//

#import "MyViewController.h"
#import "HMLockitronStatic.h"
#import "MyLockDetailsTableVC.h"

@interface MyViewController () <UITableViewDataSource, UITableViewDelegate, HMLockitronAccountDelegate>
//@property (strong) NSString *access_token;
@property (strong) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonIcon;
@end

@implementation MyViewController {
    BOOL lockitronIsReady;
    NSDateFormatter *dateFormatter;
}
- (void)viewWillAppear:(BOOL)animated {
    [HMLockitronAccount startWithClientID:@"f746dbc45b5cfdc820cc9da425d25d4ed48681686c99f537719ae94982c5127a" clientSecret:@"ac7ef86c1c915d13f67c8d388fb81d95c1b650d7fa2cd8c61c84e3f1907d6997" URIcallback:@"tronlockv2://uricallback" delegate:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view has been loaded");
	// Do any additional setup after loading the view, typically from a nib.

}

- (void)lockitronIsReady
{
    //[SVProgressHUD dismiss];
    [self.tableView reloadData];
    //[_settingsBarButtonIcon setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[HMLockitronAccount userAuthenticated].avatar_url]]];


}

- (void)lockitronChangedLockState:(LTLock *)lock to:(NSInteger)state
{
    NSUInteger index = [[HMLockitronAccount locksList] indexOfObject:lock];
    
    LTLockCell *cell = (LTLockCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
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
    return [HMLockitronAccount locksList].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LockCell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    LTLockCell *cell = [[LTLockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setDelegate:self];
    
    LTLock *lock = (LTLock *)[[HMLockitronAccount locksList] objectAtIndex:indexPath.row];
    //_lockName.text = lock.name;
    cell.name.text = lock.name;
    cell.button.tag = indexPath.row;
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MMM dd yy hh:mm a"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:lock.time_zone]];
    NSTimeInterval timeSince = [lock.next_wake timeIntervalSinceNow];
    cell.details.text = @"Next wake: ";
    if (timeSince < 0) {
        cell.details.text = @"Awake for: ";
    } else if ((timeSince / 60) > 1) {
        cell.details.text = [cell.details.text stringByAppendingString:[NSString stringWithFormat:@"%.0f mins", (timeSince / 60)]];
    } else {
        cell.details.text = [cell.details.text stringByAppendingString:[NSString stringWithFormat:@"%.0f secs", timeSince]];
    }
//    
//    NSLog(@"%@: %@", lock.name, lock.keys);
//    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}
#pragma mark UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row was selected");
    [self performSegueWithIdentifier:@"moveToSettingsVC" sender:nil];
    
}
- (IBAction)sendCommand:(UIButton *)sender {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    LTLock *lock = (LTLock *)[[HMLockitronAccount locksList] objectAtIndex:sender.tag];
    if (lock.state == LockitronSDKLockOpen) {
        [lock lock];
    } else if (lock.state == LockitronSDKLockClosed) {
        [lock unlock];
    }
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"performing segue");
    if ([segue.identifier isEqualToString:@"moveToSettingsVC"]) {
        //create an instance of SettingsVC
        MyLockDetailsTableVC *lockDetailsTableVCInstance = segue.destinationViewController;
        NSArray *listOfLocks = [HMLockitronAccount locksList];
        LTLock *selectedLock = listOfLocks[self.tableView.indexPathForSelectedRow.row];
        lockDetailsTableVCInstance.selectedLock = selectedLock;
        lockDetailsTableVCInstance.title = lockDetailsTableVCInstance.selectedLock.name;
    }
}
@end
