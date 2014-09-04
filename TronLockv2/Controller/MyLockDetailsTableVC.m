//
//  MySettingsTableVC.m
//  TronLockv2
//
//  Created by Hanlon Miller on 8/22/14.
//  Copyright (c) 2014 Hanlon Miller Inc. All rights reserved.
//

#import "MyLockDetailsTableVC.h"
#import "HMLockitronStatic.h"

@interface MyLockDetailsTableVC ()

@end

@implementation MyLockDetailsTableVC {
    NSDateFormatter *dateFormtter;
}

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
- (void)viewWillAppear:(BOOL)animated {
    dateFormtter = [NSDateFormatter new];
    [dateFormtter setDateFormat:@"MMM dd yy hh:mm a"];
    [dateFormtter setTimeZone:[NSTimeZone timeZoneWithName:_selectedLock.time_zone]];
    _lockName.text = _selectedLock.name;
    _updatedAt.text = [dateFormtter stringFromDate:_selectedLock.updated_at];
    if (_selectedLock.state == LockitronSDKLockNotConfigured) {
        _lockState.enabled = NO;
    } else {
        _lockState.enabled = YES;
        _lockState.selectedSegmentIndex = _selectedLock.state;
    }
    _handednessStatus.enabled = YES;
    if ([_selectedLock.handedness isEqualToString:@"unlocked"]) {
        _handednessStatus.on = NO;
    } else if ([_selectedLock.handedness isEqualToString:@"locked"]) {
        _handednessStatus.on = YES;
    } else {
        _handednessStatus.on = NO;
        _handednessStatus.enabled = NO;
    }
    if (_selectedLock.sms) {
        _SMSstatus.on = YES;
    } else {
        _SMSstatus.on = NO;
    }
    if (_selectedLock.next_wake) {
        _nextWake.text = [dateFormtter stringFromDate:_selectedLock.next_wake];
        _sleepIntervalSlider.value = _selectedLock.sleep_period;
        _sleepIntervalSlider.enabled = YES;
        _sleepInterval.text = [NSString stringWithFormat:@"%lu seconds", (unsigned long)_selectedLock.sleep_period];
    } else {
        _nextWake.text = @"0 seconds";
        _sleepIntervalSlider.value = 0;
        _sleepIntervalSlider.enabled = NO;
        _sleepInterval.text = @"0 seconds";
    }
    _numberOfKeys.text = [NSString stringWithFormat:@"%lu", (unsigned long)_selectedLock.keys.count];
    NSLog(@"avr_update_progress:%lu", (unsigned long)_selectedLock.avr_update_progress);
    if (_selectedLock.avr_update_progress == 0) {
        _updateAVRfirmware.enabled = NO;
    } else {
        _updateAVRfirmware.enabled = YES;
    }
    if (_selectedLock.ble_update_progress == 0) {
        _updateBLEfirmware.enabled = NO;
    } else {
        _updateBLEfirmware.enabled = YES;
    }
    _serialNumber.text = _selectedLock.serial_number;
    _lockID.text = _selectedLock.id;
}
- (IBAction)sleepIntervalSliderDidChange:(UISlider *)sender {
    _sleepInterval.text = [NSString stringWithFormat:@"%i seconds", (int)sender.value];
    [self.selectedLock changeSleepIntervalTo:[NSString stringWithFormat:@"%i", (int)sender.value]];
}
- (IBAction)sleepPeriodSliderDidChange:(UISlider *)sender {

}
- (IBAction)updateAVRfirmware:(UIButton *)sender {
}
- (IBAction)updateBluetoothFirmware:(UIButton *)sender {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
