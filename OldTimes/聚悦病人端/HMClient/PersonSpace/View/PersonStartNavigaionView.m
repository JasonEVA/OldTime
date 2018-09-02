//
//  PersonStartNavigaionView.m
//  HMClient
//
//  Created by yinqaun on 16/4/22.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonStartNavigaionView.h"

@interface PersonStartNavigaionView ()
{
    UIImageView* ivPortrait;
    UILabel* lbUserName;
    UIButton* btnSetting;
    UIButton* btnRing;
}
@end

@implementation PersonStartNavigaionView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor mainThemeColor]];
        
        ivPortrait = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40 * kScreenScale, 40 * kScreenScale)];
        [self addSubview:ivPortrait];
        [ivPortrait.layer setCornerRadius:ivPortrait.width/2];
        [ivPortrait.layer setMasksToBounds:YES];
        [ivPortrait setImage:[UIImage imageNamed:@"img_default_photo"]];
        
        lbUserName = [[UILabel alloc]init];
        [self addSubview:lbUserName];
        [lbUserName setBackgroundColor:[UIColor clearColor]];
        [lbUserName setFont:[UIFont font_30]];
        [lbUserName setTextColor:[UIColor whiteColor]];
        
        UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
        [lbUserName setText:curUser.userName];
        
        btnSetting = [[UIButton alloc]init];
        [self addSubview:btnSetting];
        [btnSetting setTitle:@"设置" forState:UIControlStateNormal];
        [btnSetting setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnSetting.titleLabel setFont:[UIFont font_28]];
        [btnSetting addTarget:self action:@selector(settingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
//        btnRing = [[FullImageButton alloc]init];
//        [self addSubview:btnRing];
//        [btnRing setImage:[UIImage imageNamed:@"icon_bell"] forState:UIControlStateNormal];
//        [btnRing addTarget:self action:@selector(bellButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

        [self subviewsLayout];
        
        
    }
    return self;
}

- (void) setUserInfo
{
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [ivPortrait sd_setImageWithURL:[NSURL URLWithString:curUser.imgUrl] placeholderImage:[UIImage imageNamed:@"img_default_photo"]];
    [lbUserName setText:curUser.userName];
}

- (void) subviewsLayout
{
    [ivPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(2.5);
        make.bottom.equalTo(self).with.offset(-11 * kScreenScale);
        make.size.mas_equalTo(ivPortrait.size);
    }];
    
    [lbUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ivPortrait);
        make.left.equalTo(ivPortrait.mas_right).with.offset(10);
    }];
    
    [btnSetting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ivPortrait);
        make.right.equalTo(self.mas_right).with.offset(-15 * kScreenScale);
        make.size.mas_equalTo(CGSizeMake(42, 25));
    }];
    
//    [btnRing mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(ivPortrait);
//        make.right.equalTo(self.mas_right).with.offset(-10 * kScreenScale);
//        make.size.mas_equalTo(CGSizeMake(25, 25));
//    }];
}

- (void) settingButtonClicked:(id) sender
{
    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－设置"];
    [HMViewControllerManager createViewControllerWithControllerName:@"PersonSettingStartViewController" ControllerObject:nil];
}
- (void) bellButtonClicked:(id) sender
{
    [HMViewControllerManager createViewControllerWithControllerName:@"SiteMessageViewController" ControllerObject:nil];
}
@end
