//
//  LTLockCell.h
//  LockitronSDKExample
//
//  Created by Sebastien THIEBAUD on 6/10/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTLockCell : UITableViewCell

@property (strong) UILabel *name;
@property (weak) id delegate;

- (void)setUnlock;
- (void)setLock;

@end
