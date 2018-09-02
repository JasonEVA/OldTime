//
//  CommonDeviceDetectHomePageView.m
//  HMClient
//
//  Created by lkl on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "CommonDeviceDetectHomePageView.h"

@interface CommonDeviceDetectHomePageView ()
{
    UIButton *soundIcon;
    UIButton *useGuideBtn;
    UIImageView *questionIcon;
    UIImageView *deviceImg;
    UILabel *lbContent;
}
@end

@implementation CommonDeviceDetectHomePageView

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
        [self addSubview:deviceImg];
        
        _bluetoothConnectIcon = [[UIImageView alloc] init];
        [self addSubview:_bluetoothConnectIcon];
        [self bluetoothConnectAnimationPlay];
        
        lbContent = [[UILabel alloc] init];
        [lbContent setText:@"请打开设备开关"];
        [lbContent setTextColor:[UIColor commonTextColor]];
        [lbContent setFont:[UIFont systemFontOfSize:18]];
        //[lbContent setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        [lbContent setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lbContent];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button.layer setMasksToBounds:YES];
        [_button.layer setCornerRadius:5.0];
        [_button setTitle:@"开始" forState:UIControlStateNormal];
        [_button.titleLabel setFont: [UIFont systemFontOfSize:15]];
        [_button setBackgroundColor:[UIColor lightGrayColor] ];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_button];
        
        [self subviewsLayout];
    }
    return self;
}

- (void)subviewsLayout
{
    [soundIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@15);
        make.top.equalTo(self).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [useGuideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(self).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [questionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(useGuideBtn.mas_left);
        make.top.equalTo(self).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [deviceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(useGuideBtn.mas_bottom).with.offset(25);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(DeviceHomePageImg_Width);
        make.height.mas_equalTo(DeviceHomePageImg_Height);
    }];
    
    [_bluetoothConnectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(deviceImg.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(195, 37));
    }];
    
    [lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bluetoothConnectIcon.mas_bottom).with.offset(14);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (void)bluetoothConnectAnimationPlay
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i = 1; i<=4; i++)
    {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"bluetooth_xy_0%d",i]];
        [array addObject:img];
    }
    //animationImages动画图片数组，数组中存放的必须是UIImage。
    _bluetoothConnectIcon.animationImages = array;
    
    //设置单次动画的持续时间(从第一张播放到最后一张的时间)
    _bluetoothConnectIcon.animationDuration = 2;
    
    //设置动画的播放次数。0表示无限播放。
    _bluetoothConnectIcon.animationRepeatCount = 0;
    
    //开始动画
    [_bluetoothConnectIcon startAnimating];
}

//血氧测试界面约束更新
- (void)detectLayoutUpdateConstraints
{
    [deviceImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(useGuideBtn.mas_bottom).with.offset(60);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(DeviceHomePageImg_Width+20);
        make.height.mas_equalTo(DeviceHomePageImg_Height+20);
    }];

    [lbContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceImg.mas_bottom).with.offset(18);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(300, 30));
    }];
    
    [_button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(lbContent.mas_bottom).with.offset(16);
        make.right.equalTo(self).with.offset(-20);
        make.height.mas_equalTo(45);
    }];
}

//血脂测试界面更新
-(void)bloodFatdetectLayoutUpdateConstraints
{
    UIImageView *bloodFatIcon = [[UIImageView alloc] init];
    [bloodFatIcon setImage:[UIImage imageNamed:@"xuezhi_icon_select"]];
    [self addSubview:bloodFatIcon];
    
    [deviceImg setImage:[UIImage imageNamed:@"pic_xuezhi_ceshi_02"]];
    [_bluetoothConnectIcon setHidden:YES];
    [lbContent setText:@"已连接设备，请插入试纸条进行测量"];
    [lbContent setFont:[UIFont systemFontOfSize:17]];
    [_button setHidden:YES];
    
    [bloodFatIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceImg.mas_bottom).with.offset(18);
        make.left.equalTo(self).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [lbContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceImg.mas_bottom).with.offset(18);
        make.left.equalTo(bloodFatIcon.mas_right).with.offset(2);
        make.size.mas_equalTo(CGSizeMake(300, 30));
    }];
}



//血脂界面约束更新
- (void)bloodFatUpdateConstraints
{
    [deviceImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(useGuideBtn.mas_bottom).with.offset(50);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(DeviceHomePageImg_Width+40);
        make.height.mas_equalTo(DeviceHomePageImg_Height+40);
    }];
    
    [_bluetoothConnectIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(deviceImg.mas_bottom).with.offset(35);
        make.size.mas_equalTo(CGSizeMake(132, 25));
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
