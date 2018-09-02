//
//  BraceletConnectedView.m
//  HMClient
//
//  Created by lkl on 2017/9/22.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BraceletConnectedView.h"

@interface BraceletConnectedView ()

@property (nonatomic, strong) UIImageView *deviceImg;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *batteryLb;
@property (nonatomic, strong) UILabel *syncTimeLb;
@end

@implementation BraceletConnectedView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.deviceImg = [[UIImageView alloc] init];
        [self addSubview:self.deviceImg];
        [self.deviceImg setImage:[UIImage imageNamed:@"icon_bracelet_120"]];
        [self.deviceImg.layer setCornerRadius:30];
        [self.deviceImg.layer setMasksToBounds:YES];
        [self.deviceImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        self.nameLb = [[UILabel alloc] init];
        [self addSubview:self.nameLb];
        [self.nameLb setText:@"设备：--"];
        [self.nameLb setTextColor:[UIColor commonTextColor]];
        [self.nameLb setFont:[UIFont font_26]];
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.deviceImg.mas_top);
            make.left.equalTo(self.deviceImg.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        
        self.batteryLb = [[UILabel alloc] init];
        [self addSubview:self.batteryLb];
        [self.batteryLb setText:@"电量：--"];
        [self.batteryLb setTextColor:[UIColor commonTextColor]];
        [self.batteryLb setFont:[UIFont font_26]];
        [self.batteryLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLb.mas_bottom).offset(8);
            make.left.right.equalTo(self.nameLb);
        }];
        
        self.syncTimeLb = [[UILabel alloc] init];
        [self addSubview:self.syncTimeLb];
        [self.syncTimeLb setText:@"最后同步时间：--"];
        [self.syncTimeLb setTextColor:[UIColor mainThemeColor]];
        [self.syncTimeLb setFont:[UIFont font_26]];
        [self.syncTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.batteryLb.mas_bottom).offset(8);
            make.left.right.equalTo(self.nameLb);
        }];
    }
    return self;
}

- (void)setBatteryInfo:(NSString *)battery{
    [self.batteryLb setText:[NSString stringWithFormat:@"电量：%@%@",battery,@"%"]];
}

- (void)setBraceletDeviceInfo:(BraceletDeviceInfo *)deviceInfo{
    
    [self.nameLb setText:[NSString stringWithFormat:@"设备：%@",deviceInfo.data_from]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    NSString *dateStr = [formatter stringFromDate:deviceInfo.date];
    [self.syncTimeLb setText:[NSString stringWithFormat:@"最后同步时间：%@",dateStr]];
}

- (void)setBraceletConnectDeviceInfo:(BraceletConnectDeviceInfo *)connectInfo{
    [self.nameLb setText:[NSString stringWithFormat:@"设备：%@",connectInfo.data_from]];
    [self.syncTimeLb setText:[NSString stringWithFormat:@"最后同步时间：%@",connectInfo.date]];
}
@end


@interface BraceletDisConnectedView ()

@property (nonatomic, strong) UILabel *promptLb;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confrimBtn;
@end

@implementation BraceletDisConnectedView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6]];
        
        UIView *bgView = [UIView new];
        [self addSubview:bgView];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.height.mas_equalTo(@200);
        }];
        
        self.promptLb = [[UILabel alloc] init];
        [self addSubview:self.promptLb];
        [self.promptLb setText:@"确认解除与手机的绑定 ？"];
        [self.promptLb setTextColor:[UIColor commonTextColor]];
        [self.promptLb setFont:[UIFont font_28]];
        [self.promptLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView).offset(15);
            make.centerX.equalTo(bgView);
        }];
        
        self.imgView = [UIImageView new];
        [self addSubview:self.imgView];
        [self.imgView setImage:[UIImage imageNamed:@"img_unbind"]];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(bgView);
            make.size.mas_equalTo(CGSizeMake(180, 51));
        }];
        
        self.cancelBtn = [UIButton new];
        [self addSubview:self.cancelBtn];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [self.cancelBtn showTopLine];
        [self.cancelBtn showRightLine];
        [self.cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(bgView);
            make.width.mas_equalTo(bgView.width/2);
            make.height.mas_equalTo(@50);
        }];
        
        self.confrimBtn = [UIButton new];
        [self addSubview:self.confrimBtn];
        [self.confrimBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.confrimBtn setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [self.confrimBtn showTopLine];
        [self.confrimBtn addTarget:self action:@selector(confrimBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.confrimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancelBtn.mas_right);
            make.right.bottom.equalTo(bgView);
            make.width.mas_equalTo(self.cancelBtn);
            make.height.mas_equalTo(@50);
        }];
        
    }
    return self;
}

- (void)confrimBtnClicked{
    [self removeFromSuperview];
    if (_confrimBlock) {
        _confrimBlock();
    }
}

- (void)cancelBtnClicked{
    [self removeFromSuperview];
}
@end
