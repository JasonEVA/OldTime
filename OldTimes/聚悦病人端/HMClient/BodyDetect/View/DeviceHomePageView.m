//
//  DeviceHomePageView.m
//  HMClient
//
//  Created by lkl on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DeviceHomePageView.h"

@interface DeviceHomePageView ()
{
    UIButton *soundIcon;
    UIButton *useGuideBtn;
    UIImageView *questionIcon;
    UIButton *measureButton;
    UIImageView *deviceImg;
    UIButton *bluetoothIcon;
    UIButton *connectIcon;
    UILabel *lbContent;
}
@end

@implementation DeviceHomePageView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        soundIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        [soundIcon setImage:[UIImage imageNamed:@"icon_sound"] forState:UIControlStateNormal];
        [self addSubview:soundIcon];
        
       useGuideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [useGuideBtn setTitle:@"使用引导" forState:UIControlStateNormal];
        [useGuideBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [useGuideBtn setTitleColor:[UIColor commonTextColor] forState:UIControlStateNormal];
        [self addSubview:useGuideBtn];
        
        questionIcon = [[UIImageView alloc] init];
        [questionIcon setImage:[UIImage imageNamed:@"icon_question"]];
        [self addSubview:questionIcon];
        
        deviceImg = [[UIImageView alloc] init];
        [deviceImg setImage:[UIImage imageNamed:@"pic_xueya_ceshi_02"]];
        [self addSubview:deviceImg];
        
        bluetoothIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        [bluetoothIcon setImage:[UIImage imageNamed:@"icon_bluetooth"] forState:UIControlStateNormal];
        [self addSubview:bluetoothIcon];
        
        connectIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        [connectIcon setImage:[UIImage imageNamed:@"icon_connect"] forState:UIControlStateNormal];
        [self addSubview:connectIcon];
        
        lbContent = [[UILabel alloc] init];
        [lbContent setText:@"请打开设备开关"];
        [lbContent setTextColor:[UIColor commonTextColor]];
        [lbContent setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [lbContent setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lbContent];
        
        measureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [measureButton.layer setMasksToBounds:YES];
        [measureButton.layer setCornerRadius:5.0];
        [measureButton setTitle:@"开始" forState:UIControlStateNormal];
        [measureButton.titleLabel setFont: [UIFont systemFontOfSize:18]];
        [measureButton setBackgroundColor:[UIColor lightGrayColor] ];
        [measureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:measureButton];
        
        //[];
    }
    return self;
}

- (void)layoutSubviews
{

    
    [soundIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@15);
        make.top.mas_equalTo(self).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [useGuideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).with.offset(-15);
        make.top.mas_equalTo(self).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [questionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(useGuideBtn.mas_left);
        make.top.mas_equalTo(self).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
#define TOP_SCROLL_HEIGHT 190.0/667.0*screenHeight
    [deviceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(useGuideBtn.mas_bottom).with.offset(20);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(290, 240));
    }];
    
    [bluetoothIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self).with.offset(-50);
        make.top.mas_equalTo(deviceImg.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [connectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self).with.offset(50);
        make.top.mas_equalTo(deviceImg.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(connectIcon.mas_bottom).with.offset(20);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    [measureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(self.bottom).with.offset(-30);
        make.right.mas_equalTo(self).with.offset(-20);
        make.height.mas_equalTo(45);
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
