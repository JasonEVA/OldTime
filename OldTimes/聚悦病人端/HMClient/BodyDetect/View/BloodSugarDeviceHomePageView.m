//
//  BloodSugarDeviceHomePageView.m
//  HMClient
//
//  Created by lkl on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodSugarDeviceHomePageView.h"

@interface BloodSugarDeviceHomePageView ()
{
    UIButton *soundIcon;
    UIImageView *questionIcon;
    UIImageView *arrowsIcon;
    UIImageView *deviceImg;
    UILabel *lbContent;
}

@end

@implementation BloodSugarDeviceHomePageView


- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        soundIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        [soundIcon setImage:[UIImage imageNamed:@"icon_sound"] forState:UIControlStateNormal];
        [self addSubview:soundIcon];
        
        _useGuideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_useGuideBtn setTitle:@"使用引导" forState:UIControlStateNormal];
        [_useGuideBtn.titleLabel setFont:[UIFont font_26]];
        [_useGuideBtn setTitleColor:[UIColor commonTextColor] forState:UIControlStateNormal];
        [self addSubview:_useGuideBtn];
        
        questionIcon = [[UIImageView alloc] init];
        [questionIcon setImage:[UIImage imageNamed:@"icon_question"]];
        [self addSubview:questionIcon];
        
        _testPeriodControl = [[UIControl alloc] init];
        [self addSubview:_testPeriodControl];
        [_testPeriodControl setBackgroundColor:[UIColor whiteColor]];
        [_testPeriodControl.layer setBorderWidth:1.0f];
        [_testPeriodControl.layer setBorderColor:[[UIColor commonBackgroundColor] CGColor]];
        [_testPeriodControl.layer setCornerRadius:3.0f];
        [_testPeriodControl.layer setMasksToBounds:YES];
        
        _lbtestPeriod = [[UILabel alloc] init];
        [_testPeriodControl addSubview:_lbtestPeriod];
        [_lbtestPeriod setText:@"请选择时段"];
        [_lbtestPeriod setTextAlignment:NSTextAlignmentCenter];
        [_lbtestPeriod setFont:[UIFont font_30]];
        [_lbtestPeriod setTextColor:[UIColor commonGrayTextColor]];
        
        arrowsIcon = [[UIImageView alloc] init];
        [_testPeriodControl addSubview:arrowsIcon];
        [arrowsIcon setImage:[UIImage imageNamed:@"icon_down_list_arrow"]];

        
        deviceImg = [[UIImageView alloc] init];
        [self addSubview:deviceImg];
        
        lbContent = [[UILabel alloc] init];
        [lbContent setTextColor:[UIColor commonTextColor]];
        [lbContent setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [lbContent setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lbContent];
        
        _measureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_measureButton.layer setMasksToBounds:YES];
        [_measureButton.layer setCornerRadius:5.0];
        [_measureButton.layer setBorderColor:[[UIColor commonBackgroundColor] CGColor]];
        [_measureButton.layer setBorderWidth:2.0f];
        [_measureButton setTitle:@"测试中……" forState:UIControlStateNormal];
        [_measureButton.titleLabel setFont: [UIFont font_30]];
        [_measureButton setBackgroundColor:[UIColor whiteColor] ];
        [_measureButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [self addSubview:_measureButton];
        
        [self subviewsLayout];
    }
    return self;
}

- (void)setRemindContent:(NSString *)content
{
    [lbContent setText:content];
}

- (void)setDeviceImage:(NSString *)image
{
    [deviceImg setImage:[UIImage imageNamed:image]];
}

- (void)subviewsLayout
{
    /*[soundIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.equalTo(self).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];*/
    
    [_useGuideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.top.equalTo(self).with.offset(5);
        make.height.mas_equalTo(@20);
    }];
    
    [questionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_useGuideBtn.mas_left);
        make.top.equalTo(self).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_testPeriodControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_useGuideBtn.mas_bottom).with.offset(15);
        make.left.mas_equalTo(10);
        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(35);
    }];
    
    
    [_lbtestPeriod mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_testPeriodControl);
        make.centerX.equalTo(_testPeriodControl);
        make.size.mas_equalTo(CGSizeMake(100, 35));
    }];
    
    [arrowsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_testPeriodControl);
        make.right.equalTo(_testPeriodControl).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [deviceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_testPeriodControl.mas_bottom).with.offset(20);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(DeviceHomePageImg_Width);
        make.height.mas_equalTo(DeviceHomePageImg_Height);
    }];
    
    [lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceImg.mas_bottom).with.offset(14);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    [_measureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(lbContent.mas_bottom).with.offset(12);
        make.right.equalTo(self).with.offset(-20);
        make.height.mas_equalTo(45);
    }];
    
}

- (void)setTestPeriodSelect:(NSString *)testPeriod
{
    [_lbtestPeriod setText:testPeriod];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
