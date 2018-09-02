//
//  MaiboboBloodPressureViewController.m
//  HMClient
//
//  Created by lkl on 2017/10/17.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "MaiboboBloodPressureViewController.h"
#import "BloodPressureDeviceHomePageView.h"
#import "BloodPresureDeviceDetectLayoutView.h"
#import "JYBluetoothManager.h"
#import "MaiboboBloodPressureBLEManager.h"
#import "BloodPressureThreeDetectViewController.h"

@interface MaiboboBloodPressureViewController ()<JYBluetoothManagerDelegate>
{
    BloodPressureDeviceHomePageView *homePageView;
    BloodPresureDeviceDetectLayoutView *detectLayoutView;
    MaiboboBloodPressureBLEManager  *bleControl;
}
@property (nonatomic, assign) BOOL isThriceDetect;
@end

@implementation MaiboboBloodPressureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithHomePage];
    bleControl = [[MaiboboBloodPressureBLEManager alloc] initWithDelegate:self];
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
    [homePageView setDeviceImg:@"pic_xueya_ceshi_maibobo"];
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
    [HMViewControllerManager createViewControllerWithControllerName:@"DeviceDetectGuidePageViewController" ControllerObject:@"XYJ_MBB"];
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
    [self at_postError:@"设备连接失败"];
}

- (void)bleDisConnected
{
    if (!self.isAppear) {
        return;
    }
    
    [self showAlertMessage:@"设备连接断开" clicked:^{
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
}

- (void)bleDeviceScanTimeOut{
    [self showAlertMessage:@"设备连接超时，您可以手动上传数据,或者重新测量" clicked:^{
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - YuwellBloodPressureBluUtilDelegate
- (void)detectBPRespondType:(BPRespondType)type{
    switch (type) {
        case BPRespondType_Connect:
        {
            //连接成功，开始测量
            Byte byte[] = {0xcc,0x80,0x02,0x03,0x01,0x02,0x00,0x02};
            NSData *data = [[NSData alloc] initWithBytes:byte length:8];
            [bleControl writeDate:data];
            break;
        }
            
        case BPRespondType_PowerOff:
        {
            [self at_postError:@"蓝牙连接断开"];
            break;
        }
            
        default:
            break;
    }
}

- (void)detectingBPValue:(NSInteger)value{
    [detectLayoutView setHeartValue:[NSString stringWithFormat:@"%ld",value]];
    
    if (![detectLayoutView.heartImage.layer animationForKey:@"animationGroup"])
    {
        [detectLayoutView setHeartImageAnimationPlay];
    }
}

- (void)detectedsystolic:(NSInteger)systolic diastolic:(NSInteger)diastolic heartRate:(NSInteger)heartRate{
    
    NSMutableDictionary* dicValue = [NSMutableDictionary dictionary];
    [dicValue setValue:[NSString stringWithFormat:@"%ld",(long)systolic] forKey:@"SSY"];
    [dicValue setValue:[NSString stringWithFormat:@"%ld",(long)diastolic] forKey:@"SZY"];
    [dicValue setValue:[NSString stringWithFormat:@"%ld",(long)heartRate] forKey:@"XL_OF_XY"];

    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dicValue setValue:[formatter stringFromDate:[NSDate date]] forKey:@"testTime"];

    [dicValue setValue:@"2" forKey:@"inputMode"];

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

- (void)detectError:(NSString *)errorMsg{
//    [self at_postError:errorMsg];
    [self showAlertMessage:errorMsg clicked:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
