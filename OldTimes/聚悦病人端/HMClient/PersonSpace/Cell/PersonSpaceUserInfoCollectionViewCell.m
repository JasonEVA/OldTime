//
//  PersonSpaceUserInfoCollectionViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/4/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonSpaceUserInfoCollectionViewCell.h"

@implementation PersonSpaceCollectionViewCell



@end

@interface PersonSpaceUserInfoCollectionViewCell ()
{
    UIImageView* ivPortrait;
    UILabel* lbUserName;
    UIButton* btnSetting;
    UIButton* btnRing;
}
@end

@implementation PersonSpaceUserInfoCollectionViewCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor mainThemeColor]];
        
        ivPortrait = [[UIImageView alloc]init];
        [self addSubview:ivPortrait];
        [ivPortrait.layer setCornerRadius:22.5];
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
        
        btnRing = [[FullImageButton alloc]init];
        [self addSubview:btnRing];
        [btnRing setImage:[UIImage imageNamed:@"icon_bell"] forState:UIControlStateNormal];
        
        [self subviewsLayout];

        
    }
    return self;
}

- (void) setUserInfo
{
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [ivPortrait sd_setImageWithURL:[NSURL URLWithString:curUser.imgUrl] placeholderImage:[UIImage imageNamed:@"icon_bell"]];
    [lbUserName setText:curUser.userName];
}

- (void) subviewsLayout
{
    [ivPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.bottom.equalTo(self).with.offset(-13);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    [lbUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ivPortrait);
        make.left.equalTo(ivPortrait.mas_right).with.offset(10);
    }];
    
    [btnSetting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ivPortrait);
        make.right.equalTo(btnRing.mas_left).with.offset(-2);
        make.size.mas_equalTo(CGSizeMake(42, 25));
    }];
    
    [btnRing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ivPortrait);
        make.right.equalTo(self.mas_right).with.offset(-8);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
}

- (void) settingButtonClicked:(id) sender
{
    [HMViewControllerManager createViewControllerWithControllerName:@"PersonSettingStartViewController" ControllerObject:nil];
}
@end

@interface PersonSpaceManageCollectionViewCell ()
{
    UIImageView* ivGird;
    UILabel* lbName;
    
    UIView* bottomLine;
    UIView* rightLine;
    
    UIImageView* ivNoOpen;
}
@end

@implementation PersonSpaceManageCollectionViewCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        ivGird = [[UIImageView alloc]init];
        [self addSubview:ivGird];
        
        lbName = [[UILabel alloc]init];
        [self addSubview:lbName];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setFont:[UIFont font_26]];
        [lbName setTextColor:[UIColor colorWithHexString:@"444444"]];
        
        bottomLine = [[UIView alloc]init];
        [self.contentView addSubview:bottomLine];
        [bottomLine setBackgroundColor:[UIColor commonControlBorderColor]];
        
        rightLine = [[UIView alloc]init];
        [self.contentView addSubview:rightLine];
        [rightLine setBackgroundColor:[UIColor commonControlBorderColor]];

        ivNoOpen = [[UIImageView alloc] init];
        [self addSubview:ivNoOpen];
        
        [self subviewsLayout];
    }
    return self;
}

- (void) subviewsLayout
{
    [ivGird mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 28));
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).with.offset(21.5);
    }];
    
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(@16);
        make.top.equalTo(ivGird.mas_bottom).with.offset(10);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80 * kScreenScale, 0.5));
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@0.5);
        make.height.equalTo(self.contentView.mas_height);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right);
    }];
    
    
    [ivNoOpen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];

}

- (void) setGirdImage:(UIImage*) icon
             GirdName:(NSString*) name
{
    [ivGird setImage:icon];
    [lbName setText:name];
}

- (void) setNoOpenImage:(BOOL)isopen
{
    if (isopen) {
        [ivNoOpen setImage:[UIImage imageNamed:@"icon_no_open_2"]];
    }
    else{
        [ivNoOpen setImage:[UIImage imageNamed:@""]];
    }
}

@end
