//
//  LTViewController.m
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/9/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "LTViewController.h"
#import "LockitronSDK.h"

@interface LTViewController ()

- (IBAction)requestLocks:(id)sender;

@end

@implementation LTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)requestLocks:(id)sender
{
    [LockitronSDK locksGranted:^(NSArray *locks) {
        NSLog(@"Locks: %@", locks);
    }];
}

@end
