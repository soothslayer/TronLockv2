//
//  LTLockCell.m
//  LockitronSDKExample
//
//  Created by Sebastien THIEBAUD on 6/10/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "LTLockCell.h"
#import <QuartzCore/QuartzCore.h>
@interface LTLockCell ()


@end
@implementation LTLockCell
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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        _colorIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 60.0, 60.0)];
//        _colorIndicatorView.backgroundColor = [UIColor grayColor];
//        [self addSubview:_colorIndicatorView];
        _name = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, (self.bounds.size.width - 140), 21)];
        _name.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_name];
        
        _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _button.frame = CGRectMake((self.bounds.size.width - 130), 5, 120, (self.bounds.size.height - 15));
        [_button setTitle:@"" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.titleLabel.textAlignment = NSTextAlignmentRight;
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _button.backgroundColor = [UIColor grayColor];
        [_button addTarget:_delegate action:@selector(sendCommand:) forControlEvents:UIControlEventTouchUpInside];
        //_button.layer.cornerRadius = 2;
        [self addSubview:_button];
        
        _details = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width - 130), (_button.bounds.size.height + 7), _button.bounds.size.width, 12)];
        _details.font = [UIFont systemFontOfSize:12];
        _details.text = @"";
        [self addSubview:_details];
        
        topLock = [UIImage imageNamed:@"top_lock.png"];
        baseLock = [UIImage imageNamed:@"base_lock.png"];
        _bottomLockView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, (((_button.bounds.size.height-(topLock.size.height+baseLock.size.height))/2)+topLock.size.height), baseLock.size.width, baseLock.size.height)];
        _bottomLockView.image = baseLock;
        [_button addSubview:_bottomLockView];
        
        _topLockView = [[UIImageView alloc] initWithFrame:CGRectMake(17.0, (((_button.bounds.size.height-(topLock.size.height+baseLock.size.height))/2)), topLock.size.width, topLock.size.height)];
        _topLockView.image = topLock;
        [_button addSubview:_topLockView];
        
    }
    return self;
}

- (void)changeButtonTextTo:(NSString *)text {
    [_button setTitle:@"Knock" forState:UIControlStateNormal];
    _button.backgroundColor = [UIColor grayColor];
    [_topLockView removeFromSuperview];
    [_bottomLockView removeFromSuperview];
}
- (void)setUnlockAnimated:(BOOL)animated
{
    [_button setTitle:@"Unlocked" forState:UIControlStateNormal];
    CGRect frame = CGRectMake(8.0, (((_button.bounds.size.height-(topLock.size.height+baseLock.size.height))/2)), topLock.size.width, topLock.size.height);
    [_button addSubview:_bottomLockView];
    [_button addSubview:_topLockView];
    
    [UIView animateWithDuration:((animated) ? 0.6 : 0.0) animations:^{
        _button.backgroundColor = [UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/250.0 alpha:1.0];
        _topLockView.frame = frame;
    }];
}

- (void)setLockAnimated:(BOOL)animated
{
    [_button setTitle:@"Locked" forState:UIControlStateNormal];
    CGRect frame = CGRectMake(17.0, (((_button.bounds.size.height-(topLock.size.height+baseLock.size.height))/2)), topLock.size.width, topLock.size.height);
    [_button addSubview:_bottomLockView];
    [_button addSubview:_topLockView];

    [UIView animateWithDuration:((animated) ? 0.6 : 0.0) animations:^{
        _button.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/250.0 alpha:1.0];
        _topLockView.frame = frame;
    }];
}
- (IBAction)sendCommand:(UIButton *)sender {
    NSLog(@"textLabeltext:%@", self.textLabel.text);
    
}

@end
