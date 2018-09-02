//
//  OrderedServiceDetContactView.m
//  HMClient
//
//  Created by yinquan on 16/11/15.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OrderedServiceDetContactView.h"

@implementation OrderedServiceDetContactView

- (id) init
{
    self = [super init];
    if (self) {
        _contactNoticeLable = [[UILabel alloc] init];
        [self addSubview:self.contactNoticeLable];
        [self.contactNoticeLable setTextColor:[UIColor commonGrayTextColor]];
        [self.contactNoticeLable setFont:[UIFont font_24]];
        [self.contactNoticeLable setText:@"温馨提示：在线咨询时间为工作日的"];
        
        _contactTimeLable = [[UILabel alloc] init];
        [self addSubview:self.contactTimeLable];
        [self.contactTimeLable setTextColor:[UIColor commonRedColor]];
        [self.contactTimeLable setFont:[UIFont font_24]];
        [self.contactTimeLable setText:@"09:00-17:30"];
        
        _contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.contactButton];
        [self.contactButton setBackgroundImage:[UIImage rectImage:CGSizeMake(150, 40) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [self.contactButton setTitle:@"联系客服" forState:UIControlStateNormal];
        [self.contactButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contactButton.titleLabel setFont:[UIFont font_26]];
        self.contactButton.layer.cornerRadius = 2.5;
        self.contactButton.layer.masksToBounds = YES;
        //contact_custom_service
        [self.contactButton setImage:[UIImage imageNamed:@"contact_custom_service"] forState:UIControlStateNormal];
        self.contactButton.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 15);
        
        _contactAdviserButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.contactAdviserButton];
        [self.contactAdviserButton setBackgroundImage:[UIImage rectImage:CGSizeMake(150, 40) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [self.contactAdviserButton setTitle:@"联系健康顾问" forState:UIControlStateNormal];
        [self.contactAdviserButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contactAdviserButton.titleLabel setFont:[UIFont font_26]];
        self.contactAdviserButton.layer.cornerRadius = 2.5;
        self.contactAdviserButton.layer.masksToBounds = YES;
        [self.contactAdviserButton setImage:[UIImage imageNamed:@"contact_health_visitor"] forState:UIControlStateNormal];
        self.contactAdviserButton.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 15);
        
        [self showBottomLine];
        [self subviewsLayout];
    }
    return self;
}

- (void) subviewsLayout
{
    
}

@end

@implementation OrderedGoodsDetContactView

- (void) subviewsLayout
{
    [self.contactNoticeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.equalTo(self).with.offset(15);
    }];
    [self.contactTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contactNoticeLable);
        make.left.equalTo(self.contactNoticeLable.mas_right);
    }];
    
    [self.contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(150, 40));
        make.top.equalTo(self.contactNoticeLable.mas_bottom).with.offset(20);
    }];
}

@end

@implementation OrderedValueAddedServiceDetContactView

- (void) subviewsLayout
{
    [self.contactNoticeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.equalTo(self).with.offset(5);
    }];
    [self.contactTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contactNoticeLable);
        make.left.equalTo(self.contactNoticeLable.mas_right);
    }];
    
    [self.contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(150, 40));
        make.top.equalTo(self.contactNoticeLable.mas_bottom).with.offset(10);
    }];
}

@end

@implementation OrderedPackageServiceDetContactView

- (void) subviewsLayout
{
    [self.contactNoticeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.equalTo(self).with.offset(5);
    }];
    [self.contactTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contactNoticeLable);
        make.left.equalTo(self.contactNoticeLable.mas_right);
    }];
    
    [self.contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(80);
        make.size.mas_equalTo(CGSizeMake(150, 40));
        make.top.equalTo(self.contactNoticeLable.mas_bottom).with.offset(10);
    }];
    
    [self.contactAdviserButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-80);
        make.size.mas_equalTo(CGSizeMake(150, 40));
        make.top.equalTo(self.contactNoticeLable.mas_bottom).with.offset(10);
    }];
}

@end
