//
//  IntergralDetailHeaderView.m
//  HMClient
//
//  Created by yinquan on 2017/7/14.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "IntergralDetailHeaderView.h"

@interface IntergralDetailChooseControl ()

@property (nonatomic, strong) UILabel* chooseLabel;
@property (nonatomic, strong) UIImageView* arrowImageView;

@end

@implementation IntergralDetailChooseControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self.chooseLabel setText:@"全部"];
        
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.chooseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.arrowImageView.mas_left).with.offset(-10);
        make.left.equalTo(self);
        make.height.mas_equalTo(@30);
    }];
}

- (void) setTitle:(NSString*) title
{
    [self.chooseLabel setText:title];
}

#pragma mark - settingAndGetting
- (UILabel*)  chooseLabel
{
    if (!_chooseLabel) {
        _chooseLabel = [[UILabel alloc] init];
        [self addSubview:_chooseLabel];
        
        [_chooseLabel setTextColor:[UIColor commonDarkGrayTextColor]];
        [_chooseLabel setFont:[UIFont systemFontOfSize:18]];
        
    }
    return _chooseLabel;
}

- (UIImageView*) arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_down_list_arrow"]];
        [self addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

@end

@interface IntergralDetailHeaderView ()

@property (nonatomic, strong) UILabel* detailLabel;

@end

@implementation IntergralDetailHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self showBottomLine];
        [self showTopLine];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(15);
    }];
    
    [self.chooseControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).with.offset(-15);
        make.height.equalTo(self).with.offset(-5);
    }];
}

#pragma mark - settingAndGetting
- (UILabel*) detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        [self addSubview:_detailLabel];
        [_detailLabel setTextColor:[UIColor commonTextColor]];
        [_detailLabel setFont:[UIFont systemFontOfSize:18]];
        [_detailLabel setText:@"积分明细"];
    }
    return _detailLabel;
}

- (IntergralDetailChooseControl*) chooseControl
{
    if (!_chooseControl) {
        _chooseControl = [[IntergralDetailChooseControl alloc] init];
        [self addSubview:_chooseControl];
    }
    return _chooseControl;
}
@end
