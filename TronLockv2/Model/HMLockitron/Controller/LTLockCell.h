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
@property (strong) UILabel *details;
@property (weak) id delegate;
@property (strong) UIButton *button;

- (void)setUnlockAnimated:(BOOL)animated;
- (void)setLockAnimated:(BOOL)animated;
- (void)changeButtonTextTo:(NSString *)text;
@end
