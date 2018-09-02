//
//  IntegalStartHeaderView.m
//  HMClient
//
//  Created by yinquan on 2017/7/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "IntegalStartHeaderView.h"

@interface IntegalStartSummaryView ()

@property (nonatomic, strong) UIImageView* vipLevelImageView;
@property (nonatomic, strong) UIImageView* portraitImageView;
@property (nonatomic, strong) UILabel* userNameLabel;
@property (nonatomic, strong) UILabel* vipLevelLabel;

@property (nonatomic, strong) UILabel* totalScoreLabel;
@property (nonatomic, strong) UILabel* totalScoreTitleLabel;
@end

@implementation IntegalStartSummaryView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self setBackgroundColor:[UIColor mainThemeColor]];
        [self setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2]];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self.portraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.vipLevelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.right.bottom.equalTo(self.portraitImageView).with.offset(-2);
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.portraitImageView).with.offset(4);
        make.left.equalTo(self.portraitImageView.mas_right).with.offset(15);
    }];
    
    [self.vipLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel);
        make.bottom.equalTo(self.portraitImageView);
    }];
    
    [self.totalScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-15);
        make.top.equalTo(self.portraitImageView);
    }];
    
    [self.totalScoreTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-15);
        make.bottom.equalTo(self.portraitImageView);
    }];
}

- (void) setIntegralSummaryModel:(IntegralSummaryModel*) model
{
    [self.totalScoreLabel setText:[NSString stringWithFormat:@"%ld", model.nowTotalNum]];
    [self.vipLevelLabel setText:[model vipLevelString]];
    [self.vipLevelImageView setImage:[self vipLevelImage:model]];
}

- (UIImage*) vipLevelImage:(IntegralSummaryModel*) model
{
    NSInteger vipLevel = [model vipLevel];
    UIImage* vipImage = [UIImage imageNamed:[NSString stringWithFormat:@"integral_level_%ld", vipLevel + 1]];
    
    return vipImage;
}

#pragma mark settingAndGetting
- (UIImageView*) portraitImageView
{
    if (!_portraitImageView) {
        _portraitImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_default_photo"]];
        [self addSubview:_portraitImageView];
        UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
        if (curUser.imgUrl) {
            [_portraitImageView sd_setImageWithURL:[NSURL URLWithString:curUser.imgUrl] placeholderImage:[UIImage imageNamed:@"img_default_photo"]];
        }
        
        _portraitImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _portraitImageView.layer.borderWidth = 0.5;
        _portraitImageView.layer.cornerRadius = 25;
        _portraitImageView.layer.masksToBounds = YES;
    }
    return _portraitImageView;
}

- (UIImageView*) vipLevelImageView
{
    if (!_vipLevelImageView) {
        _vipLevelImageView = [[UIImageView alloc] init];
        [self addSubview:_vipLevelImageView];
    
    }
    return _vipLevelImageView;
}

- (UILabel*) userNameLabel
{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        [self addSubview:_userNameLabel];
        
        [_userNameLabel setFont:[UIFont systemFontOfSize:18]];
        [_userNameLabel setTextColor:[UIColor whiteColor]];
        UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
        [_userNameLabel setText:curUser.userName];
    }
    return _userNameLabel;
}

- (UILabel*) vipLevelLabel
{
    if (!_vipLevelLabel)
    {
        _vipLevelLabel = [[UILabel alloc] init];
        [self addSubview:_vipLevelLabel];
        
        [_vipLevelLabel setFont:[UIFont systemFontOfSize:14]];
        [_vipLevelLabel setTextColor:[UIColor whiteColor]];
        
    }
    return _vipLevelLabel;
}

- (UILabel*) totalScoreLabel
{
    if (!_totalScoreLabel)
    {
        _totalScoreLabel = [[UILabel alloc] init];
        [self addSubview:_totalScoreLabel];
        
        [_totalScoreLabel setFont:[UIFont boldSystemFontOfSize:32]];
        [_totalScoreLabel setTextColor:[UIColor whiteColor]];
        [_totalScoreLabel setText:@"0"];
        
    }
    return _totalScoreLabel;
}

- (UILabel*) totalScoreTitleLabel
{
    if (!_totalScoreTitleLabel)
    {
        _totalScoreTitleLabel = [[UILabel alloc] init];
        [self addSubview:_totalScoreTitleLabel];
        
        [_totalScoreTitleLabel setFont:[UIFont systemFontOfSize:12]];
        [_totalScoreTitleLabel setTextColor:[UIColor whiteColor]];
        [_totalScoreTitleLabel setText:@"总积分"];
    }
    return _totalScoreTitleLabel;
}

@end

@interface IntegalStartHeaderView ()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* integralOverdueLable;

@end

@implementation IntegalStartHeaderView


- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray* colors = @[[UIColor colorWithHexString:@"31c9ba"], [UIColor colorWithHexString:@"3cd395"]];
        UIImage* patternImage = [UIImage gradientColorImageFromColors:colors gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(kScreenWidth, 182)];
        [self setBackgroundColor:[UIColor colorWithPatternImage:patternImage]];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 36));
        make.left.equalTo(self).with.offset(10);
        make.top.equalTo(self).with.offset(24);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(31);
    }];
    
    [self.summaryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(65, 15, 38, 15));
    }];
    
    [self.integralOverdueLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.summaryView.mas_bottom).with.offset(10);
    }];
}

- (void) setIntegralSummaryModel:(IntegralSummaryModel*) model
{
    [self.summaryView setIntegralSummaryModel:model];
    
    NSDate* today = [NSDate date];
    if (today.month > 6)
    {
        //下半年
        [self.integralOverdueLable setText:[NSString stringWithFormat:@"您有%ld健康币，于12月31日即将过期，请尽快兑换。", model.junTotalNum]];
    }
    else
    {
        //上半年
        [self.integralOverdueLable setText:[NSString stringWithFormat:@"您有%ld健康币，于06月30日即将过期，请尽快兑换。", model.decTotalNum]];
    }
    
    [self.integralOverdueLable setHidden:YES];
}

#pragma mark - settingAndGetting
- (UIButton*) backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_backButton];
        [_backButton setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
        [_backButton setImageEdgeInsets:UIEdgeInsetsMake(9, 12, 9, 12)];
    }
    return _backButton;
}

- (UILabel*) titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setText:@"我的积分"];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (IntegalStartSummaryView*) summaryView
{
    if(!_summaryView)
    {
        _summaryView = [[IntegalStartSummaryView alloc] init];
        [self addSubview:_summaryView];
    }
    return _summaryView;
}

- (UILabel*) integralOverdueLable
{
    if (!_integralOverdueLable) {
        _integralOverdueLable = [[UILabel alloc] init];
        [self addSubview:_integralOverdueLable];
        
        [_integralOverdueLable setFont:[UIFont systemFontOfSize:13]];
        [_integralOverdueLable setTextColor:[UIColor whiteColor]];
    }
    return _integralOverdueLable;
}
@end
