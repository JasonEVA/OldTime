//
//  BodyTemperatureDetectResultView.m
//  HMClient
//
//  Created by yinquan on 17/4/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BodyTemperatureDetectResultView.h"

@interface BodyTemperatureDetectResultView ()

@property (nonatomic, readonly) UIView* headerView;
@property (nonatomic, readonly) UILabel* headerLable;
@property (nonatomic, readonly) UILabel* resultLable;

@end

@implementation BodyTemperatureDetectResultView

@synthesize headerView = _headerView;
@synthesize headerLable = _headerLable;
@synthesize resultLable = _resultLable;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self.headerView setBackgroundColor:[UIColor whiteColor]];
        [self showBottomLine];
        [self showTopLine];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(15);

    }];
    
    [self.headerLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.right.equalTo(self.headerView);
        make.centerY.equalTo(self.headerView);
    }];
    
    [self.resultLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(44);
        make.left.greaterThanOrEqualTo(self).with.offset(12.5);
        make.right.lessThanOrEqualTo(self).with.offset(-12.5);
        make.bottom.equalTo(self).with.offset(-8);
    }];
}

- (void) setUserAlertResult:(NSString*) userAlertResult
{
    [self.resultLable setText:userAlertResult];
    CGFloat resultHeihgt = [userAlertResult heightSystemFont:self.resultLable.font width:(kScreenWidth - 25)];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:(resultHeihgt + 55)]);
    }];
    
}

#pragma mark settingAndGetting
- (UIView*) headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] init];
        [self addSubview:_headerView];
    }
    return _headerView;
}

- (UIView*) headerLable
{
    if (!_headerLable)
    {
        _headerLable = [[UILabel alloc] init];
        [self.headerView addSubview:_headerLable];
        [_headerLable setTextColor:[UIColor mainThemeColor]];
        [_headerLable setFont:[UIFont boldFont_32]];
        [_headerLable setText:@"测量结果"];
    }
    return _headerLable;
}

- (UILabel*) resultLable
{
    if (!_resultLable)
    {
        _resultLable = [[UILabel alloc] init];
        [self addSubview:_resultLable];
        [_resultLable setTextColor:[UIColor commonTextColor]];
        [_resultLable setTextAlignment:NSTextAlignmentCenter];
        [_resultLable setNumberOfLines:0];
        [_resultLable setFont:[UIFont font_28]];
        
    }
    return _resultLable;
}

@end
