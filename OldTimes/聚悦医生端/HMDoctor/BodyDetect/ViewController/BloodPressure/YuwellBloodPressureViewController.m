//
//  YuwellBloodPressureViewController.m
//  HMClient
//
//  Created by lkl on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "YuwellBloodPressureViewController.h"
#import "BloodPressureDeviceHomePageView.h"
#import "BloodPresureDeviceDetectLayoutView.h"
#import "JYBluetoothManager.h"
#import "YuwellBloodPressureBLEDevice.h"
#import "BloodPressureThreeDetectViewController.h"

@interface YuwellBloodPressureViewController () <JYBluetoothManagerDelegate,YuwellBloodPressureBluUtilDelegate>
{
    BloodPressureDeviceHomePageView *homePageView;
    BloodPresureDeviceDetectLayoutView *detectLayoutView;
    YuwellBloodPressureBLEDevice  *bleControl;

    BOOL isResult;
}
@property (nonatomic, assign) BOOL isThriceDetect;

@property (nonatomic, assign) BOOL hasThriceVC;

@end

@implementation YuwellBloodPressureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initWithHomePage];
    bleControl = [[YuwellBloodPressureBLEDevice alloc] initWithDelegate:self];
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
        [bleControl disConnectPeripheral];
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
    [homePageView setDeviceImg:@"pic_xueya_ceshi_02"];
    [homePageView.startButton setHidden:YES];
    [homePageView.useGuideBtn addTarget:self action:@selector(useGuideBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [homePageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
    
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
}

- (void)initWithDetectLayoutView
{
    [homePageView removeFromSuperview];
    
    detectLayoutView = [[BloodPresureDeviceDetectLayoutView alloc] init];
    [self.view addSubview:detectLayoutView];
    [detectLayoutView.measureButton setHidden:YES];
    
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
    [HMViewControllerManager createViewControllerWithControllerName:@"DeviceDetectGuidePageViewController" ControllerObject:@"XYJ_YY"];
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

#pragma mark - YuwellBloodPressureBluUtilDelegate
- (void) detectingPressure:(NSInteger) pressure
{
    [detectLayoutView setHeartValue:[NSString stringWithFormat:@"%ld",pressure]];
    
    if (![detectLayoutView.heartImage.layer animationForKey:@"animationGroup"])
    {
        [detectLayoutView setHeartImageAnimationPlay];
    }
}

- (void) detectedsystolic:(NSInteger) systolic diastolic:(NSInteger) diastolic heartRate:(NSInteger) heartRate
{
    isResult = YES;
    
    NSMutableDictionary* dicValue = [NSMutableDictionary dictionary];
    [dicValue setValue:[NSString stringWithFormat:@"%ld",(long)systolic] forKey:@"SSY"];
    [dicValue setValue:[NSString stringWithFormat:@"%ld",(long)diastolic] forKey:@"SZY"];
    [dicValue setValue:[NSString stringWithFormat:@"%ld",(long)heartRate] forKey:@"XL_OF_XY"];
    
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

@end
