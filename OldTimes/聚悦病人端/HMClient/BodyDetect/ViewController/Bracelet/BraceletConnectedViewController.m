//
//  BraceletConnectedViewController.m
//  HMClient
//
//  Created by lkl on 2017/9/22.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BraceletConnectedViewController.h"
#import "BraceletConnectedView.h"
#import "BraceletDeviceInfo.h"
#import "DeviceManagerViewController.h"
#import "SEMainStartViewController.h"
#import "UIBarButtonItem+BackExtension.h"
#import <BLE3Framework/BLE3Framework.h>
#import "PersonDevicesItem.h"

@interface BraceletConnectedViewController ()<BLELib3Delegate>

@property (nonatomic, strong) BraceletConnectedView *connectedView;
@property (nonatomic, strong) UIButton *disConnectBtn;
@property (nonatomic, strong) BraceletDisConnectedView *disConnectedView;

@end

@implementation BraceletConnectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"已连接"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    //监听点击返回按钮,回到我的设备页面
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageNamed:@"back.png" targe:self action:@selector(backUp)];
    
    [self configElements];
    
    NSInteger state = [[BLELib3 shareInstance] state];
    if (state == kBLEstateDidConnected) {
        [self.navigationItem setTitle:@"已绑定"];
        [self.disConnectBtn setEnabled:YES];
    }else {
        [[BLELib3 shareInstance] reConnectDevice];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [BLELib3 shareInstance].delegate = self;
    [[BLELib3 shareInstance] readDeviceBattery];
    
    //如果从连接界面跳转过来的，请求数据
    if (self.paramObject && [self.paramObject isKindOfClass:[NSString class]]) {
        NSString *isJump = self.paramObject;
        if ([isJump isEqualToString:@"Y"]) {
            [[BLELib3 shareInstance] getCurrentSportData];
        }
    }
    else{   //如果设备已绑定，最后同步时间从本地取
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ([userDefault objectForKey:@"SH_IWINfo"]) {
            
            BraceletConnectDeviceInfo *connectInfo = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefault objectForKey:@"SH_IWINfo"]];;
            [self.connectedView setBraceletConnectDeviceInfo:connectInfo];
        }
        [userDefault synchronize];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interface Method
//回到我的设备页面
- (void)backUp
{
    NSArray* vcList = self.navigationController.viewControllers;
    
    [vcList enumerateObjectsUsingBlock:^(UIViewController *controller, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([controller isKindOfClass:[DeviceManagerViewController class]] || [controller isKindOfClass:[SEMainStartViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            *stop = YES;
        }
    }];
    
    //已绑定设备，存储信息
    PersonDevicesDetail *detailItem = [[PersonDevicesDetail alloc] init];
    detailItem.deviceName = @"埃微手环";
    detailItem.deviceIcon = @"icon_bracelet";
    detailItem.deviceNickName = @"埃微手环";
    detailItem.deviceCode = @"SH_AW";
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:detailItem];
    [userDefault setObject:data forKey:@"SH"];
    [userDefault synchronize];
    
}

#pragma mark - Private Method
// 设置元素控件
- (void)configElements {
    
    [self.view addSubview:self.connectedView];
    [self.connectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(@100);
    }];
    
    [self.view addSubview:self.disConnectBtn];
    [self.disConnectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.connectedView.mas_bottom).offset(15);
        make.height.mas_equalTo(@40);
    }];
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - Override

#pragma mark - Action
//解除绑定
- (void)disConnectBtnClick{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.disConnectedView];

    [self.disConnectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(keyWindow);
    }];
    
    __weak typeof(self)weakSelf = self;
    self.disConnectedView.confrimBlock = ^{
        //返回到绑定界面
        [[BLELib3 shareInstance] unConnectDevice];
        
        NSArray* vcList = weakSelf.navigationController.viewControllers;
        
        [vcList enumerateObjectsUsingBlock:^(UIViewController *controller, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([controller isKindOfClass:[DeviceManagerViewController class]]) {
                [weakSelf.navigationController popToViewController:controller animated:YES];
                *stop = YES;
            }
        }];

        //解除绑定，删除手环存储信息
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault removeObjectForKey:@"SH"];
        [userDefault removeObjectForKey:@"SH_IWINfo"];
        [userDefault synchronize];
        
        //解除与这个设备的连接
        NSURL *url = [NSURL URLWithString:@"App-Prefs:root=Bluetooth"];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    };

}

#pragma mark - Init
- (BraceletConnectedView *)connectedView{
    if (!_connectedView) {
        _connectedView = [BraceletConnectedView new];
        [_connectedView setBackgroundColor:[UIColor whiteColor]];
    }
    return _connectedView;
}

- (BraceletDisConnectedView *)disConnectedView{
    if (!_disConnectedView) {
        _disConnectedView = [BraceletDisConnectedView new];
    }
    return _disConnectedView;
}

- (UIButton *)disConnectBtn{
    if (!_disConnectBtn) {
        _disConnectBtn = [[UIButton alloc] init];
        [_disConnectBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
        [_disConnectBtn.titleLabel setFont:[UIFont font_28]];
        [_disConnectBtn setTitleColor:[UIColor commonTextColor] forState:UIControlStateNormal];
        [_disConnectBtn setBackgroundColor:[UIColor whiteColor]];
        [_disConnectBtn addTarget:self action:@selector(disConnectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _disConnectBtn;
}

#pragma mark - BLELib3Delegate
- (void)setBLEParameterAfterConnect {
    
}

- (void)updateDeviceInfo:(ZeronerDeviceInfo *)deviceInfo{
    [[NSUserDefaults standardUserDefaults] setObject:deviceInfo.bleAddr forKey:@"BIND_DEVICE_MACADRESS"];
    NSLog(@"获取到设备信息 :%@",deviceInfo);
}

- (void)updateBattery:(ZeronerDeviceInfo *)deviceInfo{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *batLevel = [NSString stringWithFormat:@"%ld",deviceInfo.batLevel];
        [self.connectedView setBatteryInfo:batLevel];
        
        NSInteger state = [[BLELib3 shareInstance] state];
        if (state == kBLEstateDidConnected) {
            [self.navigationItem setTitle:@"已绑定"];
            [self.disConnectBtn setEnabled:YES];
        }else {
            [self.navigationItem setTitle:@"未绑定"];
            [self.disConnectBtn setEnabled:NO];
        }
    });
}

- (void)updateCurrentWholeDaySportData:(NSDictionary *)dict{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (kDictIsEmpty(dict)) {
            return;
        }
        BraceletDeviceInfo *deviceInfo = [BraceletDeviceInfo mj_objectWithKeyValues:dict];
        [self.connectedView setBraceletDeviceInfo:deviceInfo];
    });
}
@end
