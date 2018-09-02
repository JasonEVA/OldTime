//
//  U80LHBloodPressureViewController.m
//  HMClient
//
//  Created by lkl on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "U80LHBloodPressureViewController.h"
#import "BloodPressureDeviceHomePageView.h"
#import "BloodPresureDeviceDetectLayoutView.h"
#import "U80LHBloodPressureBLEDevice.h"
#import "BloodPressureThreeDetectViewController.h"

@interface U80LHBloodPressureViewController ()<U80LHBloodPressureDelegate>
{
    BloodPressureDeviceHomePageView *homePageView;
    BloodPresureDeviceDetectLayoutView *detectLayoutView;
    U80LHBloodPressureBLEDevice  *bleControl;

    BOOL isResult;
}
@property (nonatomic, assign) BOOL isThriceDetect;
@property (nonatomic, assign) BOOL hasThriceVC;
@end

@implementation U80LHBloodPressureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initWithHomePage];
    bleControl = [[U80LHBloodPressureBLEDevice alloc] initWithDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    if (bleControl) {
        //停止扫描并断开连接
        [bleControl stopScanning];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (bleControl && bleControl.currentCentralManagerState == BLEStatePoweredOn){
        [bleControl startScanning];
    }
}

#pragma mark -- init
- (void)initWithHomePage
{
    homePageView = [[BloodPressureDeviceHomePageView alloc] init];
    [self.view addSubview:homePageView];
    [homePageView setDeviceImg:@"pic_xueya_ceshi_03"];
    [homePageView.useGuideBtn addTarget:self action:@selector(useGuideBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [homePageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
}

- (void)initWithDetectLayoutView
{
    [homePageView removeFromSuperview];
    
    detectLayoutView = [[BloodPresureDeviceDetectLayoutView alloc] init];
    [self.view addSubview:detectLayoutView];
    
    [detectLayoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Method
- (void)useGuideBtnClick
{
    [HMViewControllerManager createViewControllerWithControllerName:@"DeviceDetectGuidePageViewController" ControllerObject:@"XYJ_YRN"];
}


- (void)buttonStateChange
{
    [detectLayoutView.measureButton setTitle:@"测量中……" forState:UIControlStateNormal];
    [detectLayoutView.measureButton setEnabled:NO];
    //给蓝牙发指令（写数据）
    Byte byte[] = {0xFD,0xFD,0xFA,0x05,0X0D, 0x0A};
    
    NSData *data = [[NSData alloc] initWithBytes:byte length:6];
    
    [bleControl writeDate:data];
}

#pragma mark --  JYBluetoothManagerDelegate
- (void)currentCentralManagerStatus:(BLEStatus)status{
    switch (status) {
        case BLEStatePoweredOff:
        {
            [homePageView setRemindContent:@"请开启手机蓝牙"];
            break;
        }
            
        case BLEStatePoweredOn:
        {
            [homePageView setRemindContent:@"请打开设备开关"];
            [homePageView startBluetoothConnectAnimationPlay];
            [bleControl startScanning];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 连接设备
- (void)bleConnectSuccess
{
    [self initWithDetectLayoutView];
    [detectLayoutView.measureButton addTarget:self action:@selector(buttonStateChange) forControlEvents:UIControlEventTouchUpInside];
}

- (void)bleConnectFailed
{
}

- (void)bleDisConnected
{
    //备注：当血压计测量（数据正确）完成之后，设备蓝牙会自动断开
    if (isResult)
    {
        return;
    }
    
    if (!self.isAppear) {
        return;
    }
    [self showAlertMessage:@"设备连接断开" clicked:^{
        
        NSArray *vcs = self.navigationController.viewControllers;
        [vcs enumerateObjectsUsingBlock:^(HMBasePageViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([vc isKindOfClass:[BloodPressureThreeDetectViewController class]]) {
                [self.navigationController popViewControllerAnimated:YES];
                _hasThriceVC = YES;
                return;
            }
        }];
        
        if (!_hasThriceVC) {
            _hasThriceVC = NO;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)bleDeviceScanTimeOut{
    [self showAlertMessage:@"设备连接超时，您可以手动上传数据,或者重新测量" clicked:^{
        
        NSArray *vcs = self.navigationController.viewControllers;
        [vcs enumerateObjectsUsingBlock:^(HMBasePageViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([vc isKindOfClass:[BloodPressureThreeDetectViewController class]]) {
                [self.navigationController popViewControllerAnimated:YES];
                _hasThriceVC = YES;
                return;
            }
        }];
        
        if (!_hasThriceVC) {
            _hasThriceVC = NO;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark --BloodPressureBluetoothControlResultDelegate

- (void)detectingPressure:(NSInteger) pressure
{
    [detectLayoutView setHeartValue:[NSString stringWithFormat:@"%ld",pressure]];
    
    if (![detectLayoutView.heartImage.layer animationForKey:@"animationGroup"])
    {
        [detectLayoutView setHeartImageAnimationPlay];
    }
}

- (void)detectedWithDictionary:(NSDictionary *)dic
{
    NSMutableDictionary* dicValue = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dicValue setValue:[formatter stringFromDate:[NSDate date]] forKey:@"testTime"];
    
    [dicValue setValue:@"2" forKey:@"inputMode"];
    [dicValue setValue:self.userId forKey:@"userId"];
    
    //如果是设备监测，则下次测量默认为设备监测
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"0" forKey:@"XYManualInputTpye"];
    [userDefaults synchronize];
    
    NSArray *vcs = self.navigationController.viewControllers;
    [vcs enumerateObjectsUsingBlock:^(HMBasePageViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([vc isKindOfClass:[BloodPressureThreeDetectViewController class]] && [vcs[vcs.count-2] isKindOfClass:[BloodPressureThreeDetectViewController class]]) {
            _isThriceDetect = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:BloodPressureDetectResultNotify object:nil userInfo:dicValue];
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
    }];
    
    if (!_isThriceDetect) {
        
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureThreeDetectViewController" ControllerObject:dicValue];
    }
}

- (void)measureBloodPressureError:(float)value
{
    switch ((int)value)
    {
        case 14:
            [self showAlertMessage:@"EEPROM异常"];
            break;
        case 1:
            [self showAlertMessage:@"人体心跳信号太小或压力突降"];
            break;
        case 2:
            [self showAlertMessage:@"杂讯干扰"];
            break;
        case 3:
            [self showAlertMessage:@"充气时间过长"];
            break;
        case 5:
            [self showAlertMessage:@"测得的结果异常"];
            break;
        case 12:
            [self showAlertMessage:(@"校正异常 ")];
            break;
        case 11:
            [self showAlertMessage:@"电源低电压"];
            break;
            
        default:
            break;
    }
}

@end
