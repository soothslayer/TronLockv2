//
//  LTLockCell.m
//  LockitronSDKExample
//
//  Created by Sebastien THIEBAUD on 6/10/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "LTLockCell.h"

@implementation LTLockCell
{
    UIView *_colorIndicatorView;
    UILabel *_descriptionLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _colorIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 60.0, 60.0)];
        _colorIndicatorView.backgroundColor = [UIColor grayColor];
        [self addSubview:_colorIndicatorView];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 8.0, 240.0, 30.0)];
        _name.backgroundColor = [UIColor clearColor];
        _name.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0];
        _name.textColor = [UIColor blackColor];
        _name.text = @"Lock";
        [self addSubview:_name];
        
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 30.0, 240.0, 25.0)];
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18.0];
        _descriptionLabel.textColor = [UIColor blackColor];
        _descriptionLabel.text = @"Unconfigured.";
        [self addSubview:_descriptionLabel];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [_colorIndicatorView addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)setUnlock
{
    _colorIndicatorView.backgroundColor = [UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/250.0 alpha:1.0];
    _descriptionLabel.text = @"This lock is open.";
}

- (void)setLock
{
    _colorIndicatorView.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/250.0 alpha:1.0];
    _descriptionLabel.text = @"This lock is locked.";
}

@end
