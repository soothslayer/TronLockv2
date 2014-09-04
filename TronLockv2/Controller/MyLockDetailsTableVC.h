//
//  MySettingsTableVC.h
//  TronLockv2
//
//  Created by Hanlon Miller on 8/22/14.
//  Copyright (c) 2014 Hanlon Miller Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMLockitronAccount.h"
@class LTLock;

@interface MyLockDetailsTableVC: UITableViewController
@property (strong) LTLock *selectedLock;

@property (strong, nonatomic) IBOutlet UILabel *lockName;
@property (strong, nonatomic) IBOutlet UILabel *updatedAt;
@property (strong, nonatomic) IBOutlet UISegmentedControl *lockState;
@property (strong, nonatomic) IBOutlet UISwitch *handednessStatus;
@property (strong, nonatomic) IBOutlet UISwitch *SMSstatus;
@property (strong, nonatomic) IBOutlet UILabel *nextWake;
@property (strong, nonatomic) IBOutlet UILabel *numberOfPendingCommands;
@property (strong, nonatomic) IBOutlet UILabel *numberOfKeys;
@property (strong, nonatomic) IBOutlet UISlider *sleepIntervalSlider;
@property (strong, nonatomic) IBOutlet UILabel *sleepInterval;
@property (strong, nonatomic) IBOutlet UIButton *updateAVRfirmware;
@property (strong, nonatomic) IBOutlet UIButton *updateBLEfirmware;
@property (strong, nonatomic) IBOutlet UILabel *serialNumber;
@property (strong, nonatomic) IBOutlet UILabel *lockID;

@end
