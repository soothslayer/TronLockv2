//
//  HMLockCellTableViewCell.h
//  TronLockv2
//
//  Created by Hanlon Miller on 8/15/14.
//  Copyright (c) 2014 Hanlon Miller Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMLockCell : UITableViewCell
@property (strong) UILabel *name;
@property (strong) UILabel *detail;
@property (weak) id delegate;
@property (strong) UIButton *unlock_button;
@property (strong) UIButton *lock_button;

- (void)setUnlockAnimated:(BOOL)animated;
- (void)setLockAnimated:(BOOL)animated;
- (void)changeButtonTextToKnock;
@end
