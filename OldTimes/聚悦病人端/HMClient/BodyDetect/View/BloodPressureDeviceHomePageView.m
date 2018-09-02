//
//  BloodPressureDeviceHomePageView.m
//  HMClient
//
//  Created by lkl on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodPressureDeviceHomePageView.h"

@interface BloodPressureDeviceHomePageView ()
{
    UIButton *soundIcon;
    UIImageView *questionIcon;
    UIImageView *deviceImg;
    UIImageView *bluetoothConnectIcon;
    UILabel *lbContent;
}
@end

@implementation BloodPressureDeviceHomePageView

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
        
        deviceImg = [[UIImageView alloc] init];
        [self addSubview:deviceImg];
        
        bluetoothConnectIcon = [[UIImageView alloc] init];
        [self addSubview:bluetoothConnectIcon];
        [bluetoothConnectIcon setImage:[UIImage imageNamed:@"bluetooth_xy_01"]];
        //[self bluetoothConnectAnimationPlay];
        
        lbContent = [[UILabel alloc] init];
        [lbContent setText:@"请打开设备开关"];
        [lbContent setTextColor:[UIColor commonTextColor]];
        [lbContent setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [lbContent setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lbContent];
        
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startButton.layer setMasksToBounds:YES];
        [_startButton.layer setCornerRadius:5.0];
        [_startButton setTitle:@"开始" forState:UIControlStateNormal];
        [_startButton.titleLabel setFont: [UIFont font_30]];
        [_startButton setBackgroundColor:[UIColor lightGrayColor] ];
        [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_startButton];

        [self subviewsLayout];
    }
    return self;
}

- (void)subviewsLayout
{
    /*[soundIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@15);
        make.top.equalTo(self).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];*/
    
    [_useGuideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(self).with.offset(5);
        make.height.mas_equalTo(@20);
    }];
    
    [questionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_useGuideBtn.mas_left);
        make.top.equalTo(self).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [deviceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_useGuideBtn.mas_bottom).with.offset(25);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(DeviceHomePageImg_Width);
        make.height.mas_equalTo(DeviceHomePageImg_Height);
    }];
    
    [bluetoothConnectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(deviceImg.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(156, 30));
    }];
    
    [lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bluetoothConnectIcon.mas_bottom).with.offset(14);
        make.centerX.equalTo(self);
    }];
    
    [_startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(lbContent.mas_bottom).with.offset(12);
        make.right.equalTo(self).with.offset(-20);
        make.height.mas_equalTo(45);
    }];
    
}

- (void)setDeviceImg:(NSString *)aImage
{
    [deviceImg setImage:[UIImage imageNamed:aImage]];
}

- (void)setRemindContent:(NSString *)content
{
    [lbContent setText:content];
}

- (void)startBluetoothConnectAnimationPlay
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i = 1; i<=4; i++)
    {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"bluetooth_xy_0%d",i]];
        [array addObject:img];
    }
    //animationImages动画图片数组，数组中存放的必须是UIImage。
    bluetoothConnectIcon.animationImages = array;
    
    //设置单次动画的持续时间(从第一张播放到最后一张的时间)
    bluetoothConnectIcon.animationDuration = 2;
    
    //设置动画的播放次数。0表示无限播放。
    bluetoothConnectIcon.animationRepeatCount = 0;
    
    //开始动画
    [bluetoothConnectIcon startAnimating];
}


@end
