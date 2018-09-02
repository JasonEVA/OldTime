//
//  MissionShowSubBtn.m
//  launcher
//
//  Created by Kyle He on 15/8/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MissionShowSubBtn.h"
#import "Masonry.h"
#import "UIColor+Hex.h"
@interface MissionShowSubBtn ()

@property(nonatomic, strong) UILabel  *countLbl;
@property(nonatomic, strong) UIImageView  *indicateView;

@end

@implementation MissionShowSubBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    [self addSubview:self.indicateView];
    [self.indicateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.countLbl];
    [self.countLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.indicateView.mas_right).offset(-20);
    }];
}


#pragma mark - interface method
- (void)setCountWithStr:(NSString *)str
{
    self.countLbl.text = str;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.isShow = !self.isShow;
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Setter
- (void)setIsShow:(BOOL)isShow {
    _isShow = isShow;
    self.indicateView.image = self.isShow ? [UIImage imageNamed:@"Mission_folder_on"] : [UIImage imageNamed:@"Mission_folder_off"];
}

#pragma mark - Initializer
- (UILabel *)countLbl
{
    if (!_countLbl)
    {
        _countLbl = [[UILabel alloc] init];
        _countLbl.textColor = [UIColor mtc_colorWithHex:0x959595];
        _countLbl.font = [UIFont systemFontOfSize:12.0f];
        _countLbl.userInteractionEnabled = NO;
    }
    return _countLbl;
}

- (UIImageView *)indicateView
{
    if (!_indicateView) {
        _indicateView = [[UIImageView alloc] init];
        _indicateView.image = [UIImage imageNamed:@"Mission_folder_off"];
        _indicateView.userInteractionEnabled = NO;
    }
    return _indicateView;
}
@end
