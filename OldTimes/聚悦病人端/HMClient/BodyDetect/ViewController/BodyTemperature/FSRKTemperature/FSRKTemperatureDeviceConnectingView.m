//
//  FSRKTemperatureDeviceConnectingView.m
//  HMClient
//
//  Created by yinquan on 17/4/6.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "FSRKTemperatureDeviceConnectingView.h"

@interface FSRKTemperatureDeviceConnectingView ()
{
    NSInteger ticker;
    NSTimer* connectTimer;
}

@property (nonatomic, readonly) UIImageView* deviceImageView;
@property (nonatomic, readonly) UIImageView* connectingImageView;

@property (nonatomic, readonly) UILabel* statusLable;
@end

@implementation FSRKTemperatureDeviceConnectingView

@synthesize deviceImageView = _deviceImageView;
@synthesize connectingImageView = _connectingImageView;
@synthesize statusLable = _statusLable;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        [self stopConnecting];
    }
    return self;
}


- (void) layoutSubviews
{
    [super layoutSubviews];
    [self.deviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(99, 270));
    }];
    
    [self.statusLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).with.offset(-25);
    }];
    
    [self.connectingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.statusLable.mas_top).with.offset(-22);
    }];
}

- (void) startConnecting
{
    if (connectTimer)
    {
        return;
    }
    connectTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(connectDevice) userInfo:nil repeats:YES];

}

- (void) stopConnecting
{
    if (connectTimer) {
        [connectTimer invalidate];
        connectTimer = nil;
    }
    NSString* imageName = [NSString stringWithFormat:@"bluetooth_xy_01"];
    [self.connectingImageView setImage:[UIImage imageNamed:imageName]];
    
}

- (void) connectDevice
{
    ++ticker;
    if (ticker > 3)
    {
        ticker = 0;
    }
    
    NSString* imageName = [NSString stringWithFormat:@"bluetooth_xy_0%ld", ticker + 1];
    
    [self.connectingImageView setImage:[UIImage imageNamed:imageName]];
}

#pragma mark - setterAndGetter
- (UIImageView*) deviceImageView
{
    if (!_deviceImageView) {
        _deviceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fsrk_device_connect"]];
        [self addSubview:_deviceImageView];
    }
    
    return _deviceImageView;
}

- (UIImageView*) connectingImageView
{
    if (!_connectingImageView) {
        _connectingImageView = [[UIImageView alloc] init];
        [self addSubview:_connectingImageView];
    }
    
    return _connectingImageView;
}

- (UILabel*) statusLable
{
    if (!_statusLable) {
        _statusLable = [[UILabel alloc] init];
        [_statusLable setFont:[UIFont font_30]];
        [_statusLable setTextColor:[UIColor commonTextColor]];
        [self addSubview:_statusLable];
    }
    
    return _statusLable;
}


- (void) setDeviceStatus:(BluetoothControlStatus)deviceStatus
{
    _deviceStatus = deviceStatus;
    switch (deviceStatus)
    {
        case CentralManager_PoweredOFF:
        {
            [self.statusLable setText:@"蓝牙连接未开启，请开启手机蓝牙连接"];
            [self stopConnecting];
            break;
        }
        case CentralManager_PoweredON:
        {
            [self.statusLable setText:@"请打开设备开关"];
            [self startConnecting];
            break;
        }
        case CentralManager_Disconnect:
        {
            [self.statusLable setText:@"设备连接已断开，正在重新连接"];
            
            [self startConnecting];
            break;
        }
        case CentralManager_ConnectSussess:
        case Measurement_Results:
        {
            break;
        }
    }
}
@end
