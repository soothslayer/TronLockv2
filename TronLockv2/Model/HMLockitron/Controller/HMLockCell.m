//
//  HMLockCellTableViewCell.m
//  TronLockv2
//
//  Created by Hanlon Miller on 8/15/14.
//  Copyright (c) 2014 Hanlon Miller Inc. All rights reserved.
//

#import "HMLockCell.h"

@implementation HMLockCell
{
    UIView *_colorIndicatorView;
    UILabel *_statusLabel;
    UIImageView *_topLockView;
    UIImageView *_bottomLockView;
    UIImage *topLock;
    UIImage *baseLock;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //set up the cell
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGSize cellSize = self.bounds.size;
        //set up the images
        topLock = [UIImage imageNamed:@"top_lock.png"];
        baseLock = [UIImage imageNamed:@"base_lock.png"];
        //set up the unlock button
        _unlock_button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _unlock_button.frame = CGRectMake(10, 5, (baseLock.size.width + topLock.size.width + 5), (cellSize.height - 10));
        _unlock_button.backgroundColor = [UIColor grayColor];
        [_unlock_button addTarget:_delegate action:@selector(sendCommand:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_unlock_button];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, (self.bounds.size.width - 140), self.bounds.size.height)];
//        _name.adjustsFontSizeToFitWidth = YES;
//        [self addSubview:_name];

//        _bottomLockView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, (((_button.bounds.size.height-(topLock.size.height+baseLock.size.height))/2)+topLock.size.height), baseLock.size.width, baseLock.size.height)];
//        _bottomLockView.image = baseLock;
//        [_button addSubview:_bottomLockView];
//        
//        _topLockView = [[UIImageView alloc] initWithFrame:CGRectMake(17.0, (((_button.bounds.size.height-(topLock.size.height+baseLock.size.height))/2)), topLock.size.width, topLock.size.height)];
//        _topLockView.image = topLock;
//        [_button addSubview:_topLockView];
        
    }
    return self;
}
- (void)changeButtonTextToKnock {
//    [_button setTitle:@"Knock on Door!" forState:UIControlStateNormal];
//    _button.backgroundColor = [UIColor grayColor];
//    [_topLockView removeFromSuperview];
//    [_bottomLockView removeFromSuperview];
}
- (void)setUnlockAnimated:(BOOL)animated
{
//    [_button setTitle:@"Unlocked" forState:UIControlStateNormal];
//    CGRect frame = CGRectMake(8.0, (((_button.bounds.size.height-(topLock.size.height+baseLock.size.height))/2)), topLock.size.width, topLock.size.height);
//    [_button addSubview:_bottomLockView];
//    [_button addSubview:_topLockView];
//    
//    [UIView animateWithDuration:((animated) ? 0.6 : 0.0) animations:^{
//        _button.backgroundColor = [UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/250.0 alpha:1.0];
//        _topLockView.frame = frame;
//    }];
}

- (void)setLockAnimated:(BOOL)animated
{
//    [_button setTitle:@"Locked" forState:UIControlStateNormal];
//    CGRect frame = CGRectMake(17.0, (((_button.bounds.size.height-(topLock.size.height+baseLock.size.height))/2)), topLock.size.width, topLock.size.height);
//    [_button addSubview:_bottomLockView];
//    [_button addSubview:_topLockView];
//    
//    [UIView animateWithDuration:((animated) ? 0.6 : 0.0) animations:^{
//        _button.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/250.0 alpha:1.0];
//        _topLockView.frame = frame;
//    }];
}
- (IBAction)sendCommand:(UIButton *)sender {
    NSLog(@"textLabeltext:%@", self.textLabel.text);
    
}


@end
